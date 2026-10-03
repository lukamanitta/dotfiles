pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import "_Shared/Singletons"
import "_Shared/Components"

/**
 * Swipe/expiry wrapper for a notification shown as the pill's toast surface.
 * The shared NotifCard draws the content; the pill body behind it provides the
 * material. Clicking the body jumps to the source app; dismiss and action pills
 * consume their clicks. Dragging the body up, left or right drags the whole
 * host pill along 1:1 into the mask wall; past half the width (0.6 height going
 * up) or on a quick flick it flings out, shorter pulls spring back. Auto-expires
 * via Notifs.expireAt unless the notification is critical.
 */
Item {
    id: root

    property real s: 1
    property bool live: true
    required property var notif
    required property Item host

    /** Click the body to expand and read it in full; Open activates. */
    property bool expanded: false
    onExpandedChanged: if (root.notif) Notifs.setHeld(root.notif.id, root.expanded)
    Component.onDestruction: if (root.notif) Notifs.setHeld(root.notif.id, false)

    implicitHeight: content.implicitHeight

    /**
     * Deadline is snapshotted once: binding the interval to Notifs.expireAt
     * restarts the timer (and drifts the lifetime) every time an unrelated
     * notification replaces the map.
     */
    property double deadline: 0
    function armDeadline() { deadline = notif ? (Notifs.expireAt[notif.id] || (Date.now() + 6000)) : 0; }
    Component.onCompleted: armDeadline()

    Timer {
        interval: Math.max(300, root.deadline - Date.now())
        running: root.deadline > 0 && root.live && !swipe.pressed && !root.expanded && root.notif.urgency !== NotificationUrgency.Critical
        onTriggered: if (!root.expanded) Notifs.removePopup(root.notif)
    }

    /**
     * Same Toast instance keeps showing the stack after a swipe, so the next
     * card enters from the side the last one left through.
     */
    property real enterX: 0
    property real enterY: 0
    onNotifChanged: {
        if (!notif)
            return;
        expanded = false;
        armDeadline();
        if (enterX === 0 && enterY === 0)
            return;
        host.swipeX = enterX;
        host.swipeY = enterY;
        host.swipeFade = 0;
        enterX = 0;
        enterY = 0;
        settle.restart();
    }

    ParallelAnimation {
        id: settle
        NumberAnimation { target: root.host; property: "swipeX"; to: 0; duration: Motion.standard; easing.type: Easing.OutBack }
        NumberAnimation { target: root.host; property: "swipeY"; to: 0; duration: Motion.standard; easing.type: Easing.OutBack }
        NumberAnimation { target: root.host; property: "swipeFade"; to: 1; duration: Motion.standard; easing.type: Motion.easeStandard }
    }

    ParallelAnimation {
        id: fling
        property real toX: 0
        property real toY: 0
        NumberAnimation { target: root.host; property: "swipeX"; to: fling.toX; duration: Motion.fast; easing.type: Easing.InCubic }
        NumberAnimation { target: root.host; property: "swipeY"; to: fling.toY; duration: Motion.fast; easing.type: Easing.InCubic }
        NumberAnimation { target: root.host; property: "swipeFade"; to: 0; duration: Motion.fast; easing.type: Easing.InCubic }
        onFinished: {
            root.enterX = -fling.toX;
            root.enterY = -fling.toY;
            Notifs.removePopup(root.notif, true);
        }
    }

    /**
     * Pointer is tracked in window coords: the pill moves under the cursor
     * while dragging, so item-local deltas would collapse to zero.
     */
    MouseArea {
        id: swipe
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        preventStealing: true

        property real px: 0
        property real py: 0
        property double pt: 0
        property string axis: ""

        readonly property real slack: 8 * root.s
        readonly property real farX: root.host.width / 2
        readonly property real farY: root.host.height * 0.6

        function fadeFor(moved, far) { return 1 - 0.6 * Math.min(1, moved / far); }

        onPressed: function(m) {
            settle.stop();
            const p = mapToItem(null, m.x, m.y);
            px = p.x;
            py = p.y;
            pt = Date.now();
            axis = "";
        }
        onPositionChanged: function(m) {
            const p = mapToItem(null, m.x, m.y);
            const dx = p.x - px;
            const dy = p.y - py;
            if (axis === "" && Math.max(Math.abs(dx), Math.abs(dy)) > slack)
                axis = Math.abs(dx) > Math.abs(dy) ? "x" : "y";
            if (axis === "x") {
                root.host.swipeX = dx;
                root.host.swipeFade = fadeFor(Math.abs(root.host.swipeX), farX);
            } else if (axis === "y") {
                root.host.swipeY = Math.min(0, dy);
                root.host.swipeFade = fadeFor(-root.host.swipeY, farY);
            }
        }
        onReleased: function(m) {
            if (axis === "") {
                root.expanded = !root.expanded;
                return;
            }
            const h = root.host;
            const flick = Date.now() - pt < 250;
            const moved = axis === "x" ? Math.abs(h.swipeX) : -h.swipeY;
            const far = moved >= (axis === "x" ? farX : farY);
            if (far || (flick && moved > slack * 2)) {
                fling.toX = axis === "x" ? (h.swipeX < 0 ? -h.width : h.width) : 0;
                fling.toY = axis === "y" ? -h.height * 1.3 : 0;
                fling.restart();
            } else {
                settle.restart();
            }
        }
    }

    NotifCard {
        id: content
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        s: root.s
        notif: root.notif
        expanded: root.expanded
        onActivate: {
            Notifs.activateNotif(root.notif);
            Notifs.removePopup(root.notif, true);
        }
        onDismiss: Notifs.removePopup(root.notif, true)
        onMuteToggled: Notifs.toggleMuteApp(content.app)
        onActionInvoked: function(action) {
            action.invoke();
            if (action.identifier === "default")
                Notifs.raiseWindow(root.notif);
            Notifs.removePopup(root.notif, true);
        }
    }
}
