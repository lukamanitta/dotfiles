pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Singleton {
    id: root

    property bool dnd: false
    property var mutedApps: ({})
    /** Presentation mode, persisted via Flags. */
    readonly property string popupMode: Flags.notifMode
    property var seenIds: ({})
    property var arrivalMs: ({})
    property var popups: []
    property int tick: 0
    property var expandedApps: ({})
    property var history: []
    property var userDismissed: ({})
    property var expireAt: ({})
    property var hookedIds: ({})
    property var heldIds: ({})
    property var closedHeld: ({})
    property bool historyLoaded: false
    property string historyFile: (Quickshell.env("XDG_RUNTIME_DIR") || "/tmp") + "/quickshell-notif-history.json"

    readonly property var tracked: server.trackedNotifications.values
    readonly property int count: tracked.length + history.length

    readonly property int unread: {
        var u = 0;
        for (var i = 0; i < tracked.length; i++)
            if (!seenIds[tracked[i].id]) u++;
        return u;
    }

    readonly property var groups: {
        var map = {};
        var order = [];
        for (var i = 0; i < tracked.length; i++) {
            var n = tracked[i];
            var app = (n.appName && n.appName.length) ? n.appName : "System";
            if (map[app] === undefined) { map[app] = []; order.push(app); }
            map[app].push({ live: true, n: n, t: arrivalMs[n.id] || 0 });
        }
        for (var j = 0; j < history.length; j++) {
            var h = history[j];
            if (map[h.app] === undefined) { map[h.app] = []; order.push(h.app); }
            map[h.app].push({ live: false, n: h, t: h.ts || 0 });
        }
        function coalesce(list, it) {
            var last = list.length > 0 ? list[list.length - 1] : null;
            if (last && last.n.summary === it.n.summary && last.n.body === it.n.body) {
                last.count++;
                last.items.push(it.n);
            } else {
                list.push({ live: it.live, n: it.n, count: 1, items: [it.n] });
            }
        }
        var gs = order.map(function(app) {
            var items = map[app];
            items.sort(function(a, b) { return b.t - a.t; });
            var criticals = [];
            var entries = [];
            for (var k = 0; k < items.length; k++)
                coalesce(items[k].n.urgency === NotificationUrgency.Critical ? criticals : entries, items[k]);
            var preview = items.find(function(it) { return it.n.urgency !== NotificationUrgency.Critical; });
            return {
                app: app,
                count: items.length,
                t: items[0].t,
                newest: items[0].n,
                preview: preview ? preview.n : items[0].n,
                criticals: criticals,
                entries: entries
            };
        });
        gs.sort(function(a, b) { return b.t - a.t; });
        return gs;
    }

    function iconFor(n) {
        if (!n) return "";
        var img = n.image || "";
        var names = [];
        if (img.indexOf("image://icon/") === 0) {
            names.push(img.substring(13));
        } else if (img.length) {
            return img;
        }
        names.push(n.appIcon, n.desktopEntry, (n.appName || n.app || "").toLowerCase());
        for (var i = 0; i < names.length; i++) {
            var nm = names[i];
            if (!nm || !nm.length) continue;
            if (nm.indexOf("/") === 0 || nm.indexOf("file://") === 0) return nm;
            var p = Quickshell.iconPath(nm, true);
            if (p.length) return p;
        }
        return "";
    }

    function appKey(n) {
        return (n && n.appName && n.appName.length) ? n.appName : "System";
    }

    function muteApp(app, ms) {
        var m = Object.assign({}, root.mutedApps);
        m[app] = Date.now() + (ms > 0 ? ms : 1800000);
        root.mutedApps = m;
    }

    function unmuteApp(app) {
        var m = Object.assign({}, root.mutedApps);
        delete m[app];
        root.mutedApps = m;
    }

    function toggleMuteApp(app) {
        if (root.isMuted(app))
            root.unmuteApp(app);
        else
            root.muteApp(app, 1800000);
    }

    function isMuted(app) {
        void root.tick;
        var until = root.mutedApps[app];
        return until !== undefined && until > Date.now();
    }

    function dismissNotif(n) {
        if (!n) return;
        if (typeof n.dismiss === "function") {
            var d = Object.assign({}, userDismissed);
            d[n.id] = true;
            root.userDismissed = d;
            root.setHeld(n.id, false);
            root.removePopup(n, true);
            n.dismiss();
        } else {
            root.history = root.history.filter(function(h) { return h.id !== n.id; });
        }
    }

    function dismissEntry(e) {
        if (!e || !e.items) return;
        var d = Object.assign({}, userDismissed);
        var gone = {};
        var live = [];
        for (var i = 0; i < e.items.length; i++) {
            var n = e.items[i];
            if (typeof n.dismiss === "function") {
                d[n.id] = true;
                root.setHeld(n.id, false);
                root.removePopup(n, true);
                live.push(n);
            } else {
                gone[n.id] = true;
            }
        }
        root.userDismissed = d;
        for (var j = 0; j < live.length; j++) live[j].dismiss();
        root.history = root.history.filter(function(h) { return !gone[h.id]; });
    }

    /**
     * Focus the app's Hyprland window (workspace switch included) by matching the
     * notification's desktopEntry/appName against the live window classes.
     */
    function raiseWindow(n) {
        if (!n) return;
        var token = String(n.desktopEntry && n.desktopEntry.length ? n.desktopEntry : (n.appName || "")).toLowerCase();
        if (token.length === 0) return;
        Quickshell.execDetached(["sh", "-c",
            "addr=$(hyprctl clients -j | jq -r --arg q \"$1\" 'first(.[] | select(((.class | if . then ascii_downcase else \"\" end) | contains($q)) or ((.initialClass | if . then ascii_downcase else \"\" end) | contains($q))) | .address)'); [ -n \"$addr\" ] && hyprctl dispatch \"hl.dsp.focus({ window = \\\"address:$addr\\\" })\"",
            "sh", token]);
    }

    /**
     * Open the app behind a notification: invoke its default action when present,
     * then jump to the app's window, mirroring stock notification-center behavior.
     */
    function activateNotif(n) {
        if (!n) return;
        var acts = n.actions || [];
        for (var i = 0; i < acts.length; i++) {
            if (acts[i].identifier === "default") {
                acts[i].invoke();
                break;
            }
        }
        raiseWindow(n);
    }

    /** Inbox-row entry wrapper: activate the app, then dismiss the entry. */
    function activateEntry(e) {
        if (!e || !e.n) return;
        activateNotif(e.n);
        dismissEntry(e);
    }

    function dismissApp(app) {
        var doomed = tracked.filter(function(n) {
            return ((n.appName && n.appName.length) ? n.appName : "System") === app;
        });
        var d = Object.assign({}, userDismissed);
        for (var i = 0; i < doomed.length; i++) {
            d[doomed[i].id] = true;
            root.setHeld(doomed[i].id, false);
            root.removePopup(doomed[i], true);
        }
        root.userDismissed = d;
        for (var j = 0; j < doomed.length; j++) doomed[j].dismiss();
        root.history = root.history.filter(function(h) { return h.app !== app; });
    }

    function markAllSeen() {
        var m = {};
        for (var i = 0; i < tracked.length; i++) m[tracked[i].id] = true;
        root.seenIds = m;
    }

    function clearAll() {
        var l = tracked.slice();
        var d = Object.assign({}, userDismissed);
        for (var i = 0; i < l.length; i++) d[l[i].id] = true;
        root.userDismissed = d;
        for (var j = 0; j < l.length; j++) l[j].dismiss();
        root.history = [];
        root.popups = [];
    }

    /**
     * Drop a notification from the popup stack. While a notification is held
     * (expanded) it is refused unless `force` is set, so no timeout/fling/close
     * path can make an expanded card disappear; explicit dismiss/open actions
     * pass force.
     */
    function removePopup(n, force) {
        if (!n) return;
        if (!force && root.heldIds[n.id]) return;
        root.popups = root.popups.filter(function(p) { return p !== n; });
    }

    function toggleExpanded(app) {
        var e = Object.assign({}, expandedApps);
        e[app] = e[app] !== true;
        root.expandedApps = e;
    }

    /**
     * Snapshot a notification into history (called on close, or when a held
     * notification is finally released).
     */
    function pushHistory(n) {
        if (!n) return;
        root.history = [{
            app: (n.appName && n.appName.length) ? n.appName : "System",
            summary: n.summary,
            body: n.body,
            appIcon: n.appIcon,
            desktopEntry: n.desktopEntry,
            image: n.image,
            urgency: n.urgency,
            ts: root.arrivalMs[n.id] || Date.now(),
            id: "h" + n.id + "-" + Date.now()
        }].concat(root.history).slice(0, 50);
    }

    function cleanupClosed(n) {
        root.removePopup(n);
        var b = Object.assign({}, root.arrivalMs);
        delete b[n.id];
        root.arrivalMs = b;
        var c = Object.assign({}, root.expireAt);
        delete c[n.id];
        root.expireAt = c;
        var h = Object.assign({}, root.hookedIds);
        delete h[n.id];
        root.hookedIds = h;
    }

    /**
     * Mark a popup as held (expanded). While held it survives both its timeout
     * and the sender closing it; when released, a notification that already
     * closed is finalised into history and dropped.
     */
    function setHeld(id, held) {
        var h = Object.assign({}, root.heldIds);
        if (held)
            h[id] = true;
        else
            delete h[id];
        root.heldIds = h;
        if (!held && root.closedHeld[id]) {
            var ch = Object.assign({}, root.closedHeld);
            delete ch[id];
            root.closedHeld = ch;
            var n = null;
            for (var i = 0; i < root.popups.length; i++) {
                if (root.popups[i].id === id) { n = root.popups[i]; break; }
            }
            if (n) {
                pushHistory(n);
                cleanupClosed(n);
            }
        }
    }

    /**
     * Bind the history-snapshot handler to a notification's `closed` signal once.
     * `keepOnReload` re-runs Component.onCompleted on every QS reload over the
     * still-tracked notifications, so the id set gates re-hooks: without it each
     * reload would stack another handler and a single close would push duplicate
     * history rows. The id is cleared inside the handler so a later notification
     * reusing the id re-hooks cleanly.
     */
    function hookClosed(n) {
        if (root.hookedIds[n.id])
            return;
        var hooked = Object.assign({}, root.hookedIds);
        hooked[n.id] = true;
        root.hookedIds = hooked;
        n.closed.connect(function(reason) {
            if (root.heldIds[n.id]) {
                var ch = Object.assign({}, root.closedHeld);
                ch[n.id] = true;
                root.closedHeld = ch;
                return;
            }
            if (!root.userDismissed[n.id])
                pushHistory(n);
            else {
                var du = Object.assign({}, root.userDismissed);
                delete du[n.id];
                root.userDismissed = du;
            }
            cleanupClosed(n);
        });
    }

    function ageLabel(n) {
        void root.tick;
        var t = arrivalMs[n.id] || n.ts;
        if (!t) return "";
        var m = Math.floor((Date.now() - t) / 60000);
        if (m < 1) return "now";
        if (m < 60) return m + "m";
        return Math.floor(m / 60) + "h";
    }

    /**
     * History persisted to the runtime dir (tmpfs) so it survives a shell
     * reload but clears on logout/reboot, as requested. Entries are plain
     * JSON-safe objects.
     */
    FileView {
        id: historyStore
        path: root.historyFile
        blockLoading: true
        atomicWrites: true
        printErrors: false
    }

    Component.onCompleted: {
        var raw = historyStore.text();
        try {
            var parsed = raw && raw.length ? JSON.parse(raw) : [];
            if (Array.isArray(parsed))
                root.history = parsed;
        } catch (e) {
        }
        root.historyLoaded = true;
    }

    onHistoryChanged: if (root.historyLoaded)
        historyStore.setText(JSON.stringify(root.history))

    Timer {
        interval: 30000
        running: root.count > 0
        repeat: true
        onTriggered: root.tick++
    }

    NotificationServer {
        id: server
        keepOnReload: true
        bodySupported: true
        actionsSupported: true
        imageSupported: true

        Component.onCompleted: {
            var l = trackedNotifications.values;
            var a = Object.assign({}, root.arrivalMs);
            for (var i = 0; i < l.length; i++) {
                if (!a[l[i].id]) a[l[i].id] = Date.now();
                root.hookClosed(l[i]);
            }
            root.arrivalMs = a;
        }

        onNotification: function(n) {
            var a = Object.assign({}, root.arrivalMs);
            a[n.id] = Date.now();
            root.arrivalMs = a;
            var e = Object.assign({}, root.expireAt);
            e[n.id] = Date.now() + (n.urgency === NotificationUrgency.Low ? 4000 : 6000);
            root.expireAt = e;
            n.tracked = true;
            root.hookClosed(n);
            var critical = n.urgency === NotificationUrgency.Critical;
            if (critical || (!root.dnd && !root.isMuted(root.appKey(n))))
                root.popups = root.popups.concat([n]).slice(-3);
        }
    }
}
