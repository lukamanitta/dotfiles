pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "_Shared/Singletons"
import "_Shared/Components"
import "lib/fuzzy.js" as Fuzzy
import "lib/calc.js" as Calc

/**
 * Launcher surface built on the reusable Palette. Providers, switched by a
 * leading prefix:
 *   (none) desktop applications (ranked by fuzzy match + launch usage)
 *   >      shell commands (open other surfaces, lock/reboot, …)
 *   :      flags (Do Not Disturb, notification position, …)
 *   @      open windows, most recently focused first
 *   =      calculator (also auto-detected for a bare expression)
 */
ThePillSurface {
    id: root

    mTop: 15
    mLeft: 17
    mRight: 17
    mBottom: 14

    property var usage: ({})

    /**
     * Workspace to re-focus shortly after launching an app. The launch goes
     * through Hyprland with a workspace token so the window is placed on the
     * right workspace, but a token places it silently; when the launcher's
     * layer surface closes, Hyprland hands keyboard focus back to the last
     * window. Re-asserting the workspace after that makes the new window
     * focused (and focus follows it if it maps a moment later).
     */
    property string pendingFocusWs: ""
    /** Window to focus after the launcher's layer surface releases the keyboard. */
    property string pendingFocusAddr: ""

    Timer {
        id: focusRestore
        interval: 220
        onTriggered: {
            if (root.pendingFocusWs.length === 0)
                return;
            Hyprland.dispatch('hl.dsp.focus({ workspace = "' + root.pendingFocusWs + '" })');
            root.pendingFocusWs = "";
        }
    }

    Timer {
        id: focusWindow
        interval: 220
        onTriggered: {
            if (root.pendingFocusAddr.length === 0)
                return;
            var addr = root.pendingFocusAddr;
            root.pendingFocusAddr = "";
            Hyprland.dispatch('hl.dsp.focus({ window = "address:' + addr + '" })');
        }
    }

    readonly property string mode: {
        const q = palette.query;
        if (q.indexOf(">") === 0)
            return "cmd";
        if (q.indexOf(":") === 0)
            return "flags";
        if (q.indexOf("@") === 0)
            return "windows";
        if (q.indexOf("=") === 0)
            return "calc";
        return "apps";
    }
    readonly property string effectiveQuery: {
        if (mode === "apps")
            return palette.query;
        return palette.query.substring(1).replace(/^\s+/, "");
    }

    readonly property string usageFile: (Quickshell.env("XDG_STATE_HOME") || (Quickshell.env("HOME") + "/.local/state")) + "/LiquoRice/launcher-usage.json"

    readonly property var allEntries: {
        var src = DesktopEntries.applications.values;
        var out = [];
        for (var i = 0; i < src.length; i++)
            if (src[i] && !src[i].noDisplay)
                out.push(src[i]);
        return out;
    }

    readonly property string surfaceScript: (Quickshell.env("HOME") || "") + "/.config/hypr/scripts/open-pill-surface.sh"

    function runIpc(name) {
        Quickshell.execDetached([root.surfaceScript, name]);
    }

    /** Set the search text (IPC/debug hooks and tests). */
    function setQuery(q) {
        palette.input.text = q;
    }

    function luaString(s) {
        return '"' + String(s).replace(/\\/g, "\\\\").replace(/"/g, '\\"') + '"';
    }

    /**
     * Launch a desktop entry through Hyprland rather than Quickshell's own fork.
     * Hyprland's executor stamps the child with the workspace it was invoked on
     * (misc:initial_workspace_tracking), so the app opens on the workspace the
     * user picked even though the launcher's layer surface closing snaps focus
     * back to the last focused window's monitor.
     */
    function execEntry(entry) {
        if (!entry || !entry.command || entry.command.length === 0) {
            if (entry)
                entry.execute();
            return;
        }
        var quoted = [];
        for (var i = 0; i < entry.command.length; i++)
            quoted.push("'" + String(entry.command[i]).replace(/'/g, "'\\''") + "'");
        Hyprland.dispatch("hl.dsp.exec_cmd(" + root.luaString(quoted.join(" ")) + ")");
    }

    readonly property var commandItems: [
        {
            title: "Open inbox",
            subtitle: "link",
            glyph: "inbox",
            keywords: "notifications inbox messages",
            run: () => root.runIpc("link")
        },
        {
            title: "Open clipboard",
            subtitle: "clipboard",
            glyph: "clipboard",
            keywords: "clipboard history copy paste",
            run: () => root.runIpc("clipboard")
        },
        {
            title: "Open media",
            subtitle: "media",
            glyph: "music",
            keywords: "media music player now playing song video",
            run: () => root.runIpc("media")
        },
        {
            title: "Open power menu",
            subtitle: "power",
            glyph: "shutdown",
            keywords: "power lock reboot shutdown session",
            run: () => root.runIpc("power")
        },
        {
            title: "Open calendar",
            subtitle: "calendar",
            glyph: "clock",
            keywords: "calendar date time",
            run: () => root.runIpc("calendar")
        },
        {
            title: "Open network",
            subtitle: "network",
            glyph: "wifi",
            keywords: "network wifi ethernet connectivity",
            run: () => root.runIpc("network")
        },
        {
            title: "Open mixer",
            subtitle: "mixer",
            glyph: "mixer",
            keywords: "mixer audio volume sound brightness microphone",
            run: () => root.runIpc("mixer")
        },
        {
            title: "Toggle Do Not Disturb",
            subtitle: "dnd",
            glyph: "dnd",
            keywords: "dnd silence notifications",
            run: () => { Flags.doNotDisturb = !Flags.doNotDisturb; }
        },
        {
            title: "Toggle notification position",
            subtitle: "pill / corner",
            glyph: "bell",
            keywords: "notifications corner pill position",
            run: () => { Notifs.popupMode = Notifs.popupMode === "pill" ? "corner" : "pill"; }
        }
    ]

    function flagItems() {
        return [
            {
                title: "Do Not Disturb",
                subtitle: Flags.doNotDisturb ? "on" : "off",
                glyph: "dnd",
                keywords: "dnd silence notifications",
                run: () => { Flags.doNotDisturb = !Flags.doNotDisturb; }
            },
            {
                title: "Notification position",
                subtitle: Flags.notifMode,
                glyph: "bell",
                keywords: "notifications corner pill position",
            run: () => { Flags.notifMode = Flags.notifMode === "pill" ? "corner" : "pill"; }
            }
        ];
    }

    function mapCategory(raw) {
        const order = [["TerminalEmulator", "Terminal"], ["WebBrowser", "Browser"], ["InstantMessaging", "Chat"], ["Audio", "Media"], ["AudioVideo", "Media"], ["Video", "Media"], ["Game", "Game"], ["Development", "Dev"], ["Graphics", "Graphics"], ["Office", "Office"], ["Settings", "System"], ["System", "System"], ["Utility", "Tool"], ["Network", "Net"]];
        const cats = String(raw).split(/[;,]/);
        for (let i = 0; i < order.length; i++)
            if (cats.includes(order[i][0]))
                return order[i][1];
        return "";
    }

    function appResults(q) {
        var ranked = Fuzzy.rank(allEntries, q, root.usage);
        return ranked.map(function(e) {
            return { title: e.name, subtitle: root.mapCategory(e.categories), icon: e.icon, entry: e };
        });
    }

    /** Resolve a window class to an icon name the Palette can load, or "". */
    function appIconForClass(cls) {
        var id = String(cls || "").toLowerCase();
        if (id.length === 0)
            return "";
        var entry = DesktopEntries.byId(id + ".desktop") || DesktopEntries.byId(id);
        var name = entry && entry.icon ? entry.icon : id;
        return Quickshell.iconPath(name, true) ? name : "";
    }

    /**
     * Open windows, most recently focused first. HyprlandToplevel.class is empty
     * in this Quickshell build, but lastIpcObject carries the full client JSON,
     * including class and focusHistoryID.
     */
    function windowResults(q) {
        var tops = Hyprland.toplevels.values.slice();
        tops.sort(function(a, b) {
            var fa = a.lastIpcObject && typeof a.lastIpcObject.focusHistoryID === "number" ? a.lastIpcObject.focusHistoryID : 1e9;
            var fb = b.lastIpcObject && typeof b.lastIpcObject.focusHistoryID === "number" ? b.lastIpcObject.focusHistoryID : 1e9;
            return fa - fb;
        });

        var needle = (q || "").toLowerCase();
        var out = [];
        for (var i = 0; i < tops.length; i++) {
            var t = tops[i];
            var ipc = t.lastIpcObject || {};
            var cls = String(ipc.class || ipc.initialClass || "");
            var ws = t.workspace ? t.workspace.name : "";
            var title = String(t.title || cls || "Untitled");
            if (needle.length > 0 && (title + " " + cls + " " + ws).toLowerCase().indexOf(needle) === -1)
                continue;
            var current = typeof ipc.focusHistoryID === "number" && ipc.focusHistoryID === 0;
            out.push({
                title: title,
                subtitle: ws.length > 0 ? ("ws " + ws + (current ? " · current" : "")) : (current ? "current" : ""),
                icon: root.appIconForClass(cls),
                glyph: "app-window",
                address: t.address
            });
        }
        return out;
    }

    function calcRow(expr, force) {
        var c = Calc.evaluate(expr, force === true);
        if (!c.ok)
            return null;
        return { title: "= " + c.display, subtitle: "copy", glyph: "calc", calc: c.display };
    }

    function calcResults(q) {
        var row = root.calcRow(q, true);
        return row ? [row] : [];
    }

    function matchItems(items, q) {
        q = (q || "").toLowerCase();
        if (q.length === 0)
            return items;
        return items.filter(function(it) {
            return (it.title + " " + (it.keywords || "")).toLowerCase().indexOf(q) !== -1;
        });
    }

    readonly property var results: {
        if (mode === "cmd")
            return matchItems(commandItems, effectiveQuery);
        if (mode === "flags")
            return matchItems(flagItems(), effectiveQuery);
        if (mode === "windows")
            return windowResults(effectiveQuery);
        if (mode === "calc")
            return calcResults(effectiveQuery);

        var apps = appResults(effectiveQuery);
        var c = calcRow(effectiveQuery, false);
        if (c)
            apps.unshift(c);
        return apps;
    }

    function activate() {
        var it = results[palette.selectedIndex];
        if (!it)
            return;
        if (it.calc !== undefined) {
            Quickshell.execDetached(["sh", "-c", "printf '%s' \"$1\" | wl-copy", "_", it.calc]);
        } else if (it.address) {
            var addr = String(it.address);
            if (addr.indexOf("0x") !== 0)
                addr = "0x" + addr;
            root.pendingFocusAddr = addr;
            focusWindow.restart();
        } else if (it.entry) {
            root.pendingFocusWs = Hyprland.focusedMonitor && Hyprland.focusedMonitor.activeWorkspace ? Hyprland.focusedMonitor.activeWorkspace.name : "";
            if (it.entry.id) {
                root.usage[it.entry.id] = (root.usage[it.entry.id] || 0) + 1;
                usageStore.setText(JSON.stringify(root.usage));
            }
            root.execEntry(it.entry);
            focusRestore.restart();
        } else if (it.run) {
            it.run();
        }
        root.requestClose();
    }

    onActiveChanged: {
        if (active) {
            Hyprland.refreshToplevels();
            palette.reset();
            Qt.callLater(palette.focusField);
        }
    }

    FileView {
        id: usageStore
        path: root.usageFile
        blockLoading: true
        atomicWrites: true
        printErrors: false
    }

    Component.onCompleted: {
        var raw = usageStore.text();
        try {
            root.usage = raw && raw.length ? JSON.parse(raw) : ({});
        } catch (e) {
            root.usage = ({});
        }
    }

    Palette {
        id: palette
        anchors.fill: parent
        s: root.s
        results: root.results
        placeholder: {
            if (root.mode === "cmd")
                return "Run a command";
            if (root.mode === "flags")
                return "Toggle a flag";
            if (root.mode === "windows")
                return "Switch to a window";
            if (root.mode === "calc")
                return "Calculate";
            return "Search apps  (> cmds  : flags  @ windows  = calc)";
        }
        emptyText: root.mode === "apps" ? "No apps found"
            : (root.mode === "windows" ? "No windows found" : "No matches")
        onAccepted: root.activate()
        onDismissed: root.requestClose()
    }

    ameForm: "caret"
    amePoint: Qt.point(palette.caretPoint.x, palette.caretPoint.y)
}
