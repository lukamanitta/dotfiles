import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick
import "_Shared/Components"
import "_Shared/Singletons"

ShellRoot {
    id: root

    property string openMon: ""
    property string openSurface: ""
    /** Monitor whose pill is in keyboard-navigation mode (SUPER+P), or "". */
    property string keyboardMon: ""

    function refresh() {
        Hyprland.refreshMonitors();
        Hyprland.refreshWorkspaces();
        Hyprland.refreshToplevels();
    }

    Component.onCompleted: {
        refresh();
    }

    readonly property var refreshEvents: ({
        workspace: true, workspacev2: true,
        createworkspace: true, createworkspacev2: true,
        destroyworkspace: true, destroyworkspacev2: true,
        moveworkspace: true, moveworkspacev2: true,
        renameworkspace: true, activespecial: true,
        focusedmon: true, focusedmonv2: true,
        openwindow: true, closewindow: true,
        movewindow: true, movewindowv2: true,
        fullscreen: true,
        monitoradded: true, monitoraddedv2: true, monitorremoved: true
    })

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (root.refreshEvents[event.name]) {
                root.refresh();
            }
            root.refresh();
        }
    }

    function toggleSurface(mon, surface) {
        if (!mon || mon.length === 0)
            mon = Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : "";
        if (root.openMon === mon && root.openSurface === surface) {
            root.close();
            return;
        }
        root.openMon = mon;
        root.openSurface = surface;
    }

    function close() {
        root.openMon = "";
        root.openSurface = "";
    }

    /**
     * Toggle keyboard navigation on the focused (or given) monitor's pill,
     * mirroring how surfaces are toggled. Escape clears it from the pill.
     */
    function toggleKeyboard(mon) {
        if (!mon || mon.length === 0)
            mon = Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : "";
        root.keyboardMon = (root.keyboardMon === mon) ? "" : mon;
    }

    Binding {
        target: Notifs
        property: "dnd"
        value: Flags.doNotDisturb
    }

    IpcHandler {
        target: "pill"
        function calendar(mon: string): void { root.toggleSurface(mon, "calendar"); }
        function launcher(mon: string): void { root.toggleSurface(mon, "launcher"); }
        function link(mon: string): void { root.toggleSurface(mon, "link"); }
        function network(mon: string): void { root.toggleSurface(mon, "network"); }
        function power(mon: string): void { root.toggleSurface(mon, "power"); }
        function mixer(mon: string): void { root.toggleSurface(mon, "mixer"); }
        function keyboard(mon: string): void { root.toggleKeyboard(mon); }
        function hide(): void { root.close(); }
        function dnd(): void { Flags.doNotDisturb = !Flags.doNotDisturb; }
        function notifMode(mode: string): void {
            Flags.notifMode = (mode === "corner") ? "corner" : "pill";
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: reserve
            required property var modelData
            readonly property real s: modelData ? modelData.height / 1080 : 1
            readonly property real mVert: 6 * s
            readonly property real restHeight: 34 * s

            screen: modelData
            color: "transparent"
            exclusionMode: ExclusionMode.Normal
            exclusiveZone: restHeight + mVert * 2
            aboveWindows: true

            anchors { top: true; left: true; right: true }
            implicitHeight: restHeight + mVert * 2

            mask: emptyReserve
            Region { id: emptyReserve }
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: overlay
            required property var modelData
            readonly property real s: modelData ? modelData.height / 1080 : 1
            readonly property real mVert: 6 * s
            readonly property string surface: root.openMon === modelData.name ? root.openSurface : ""
            readonly property bool surfaceOpen: surface.length > 0
            readonly property bool keyboardNav: root.keyboardMon === modelData.name
            readonly property bool modal: surfaceOpen || pill.held

            Text {
                id: debugText
                text: ""
            }

            readonly property bool monFullscreen: {
                var mons = Hyprland.monitors.values;
                for (var i = 0; i < mons.length; i++) {
                    if (mons[i].name === modelData.name) {
                        var ws = mons[i].activeWorkspace;
                        if (!ws || !ws.hasFullscreen) return false;

                        for (var j = 0; j < ws.toplevels.values.length; j++) {
                            var tl = ws.toplevels.values[j];
                            if (tl && tl.wayland && tl.wayland.fullscreen) return true;
                        }

                        return false;
                    }
                }
                return false;
            }

            onMonFullscreenChanged: if (monFullscreen) {
                if (root.openMon === modelData.name) root.close();
                if (root.keyboardMon === modelData.name) root.keyboardMon = "";
                pill.pinned = false;
            }

            screen: modelData
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: (surfaceOpen || keyboardNav) ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

            WlrLayershell.namespace: "pill"

            anchors { top: true; left: true; right: true; bottom: true }

            mask: monFullscreen ? hiddenRegion : (modal ? fullRegion : pillRegion)
            Region { id: hiddenRegion }
            Region {
                id: pillRegion
                readonly property real baseW: Math.max(pill.width, pill.targetW)
                x: pill.x + (pill.width - baseW) / 2
                y: pill.y
                width: baseW
                height: Math.max(pill.height, pill.targetH)
            }
            Region {
                id: fullRegion
                width: overlay.width
                height: overlay.height
            }

            MouseArea {
                anchors.fill: parent
                enabled: overlay.modal
                acceptedButtons: Qt.AllButtons
                onPressed: {
                    if (overlay.surfaceOpen) {
                        root.close();
                    } else {
                        pill.pinned = false;
                    }
                }
            }

            FocusScope {
                id: focusScope
                anchors.fill: parent
                focus: overlay.surfaceOpen || overlay.keyboardNav

                HoverHandler {
                    id: overlayHover
                    onPointChanged: {
                        // Keep the pill's copy of the pointer position current
                        // so it can resolve stale hover state on surface close.
                        pill.pointerX = point.position.x
                        pill.pointerY = point.position.y
                    }
                    onHoveredChanged: {
                        pill.hovered = hovered
                    }
                }
                Keys.onPressed: (e) => {
                    if (pill.handleKey(e, true))
                        e.accepted = true;
                }
                Keys.onReleased: (e) => {
                    if (pill.handleKey(e, false))
                        e.accepted = true;
                }
                Keys.onEscapePressed: {
                    if (overlay.surfaceOpen)
                        root.close();
                    else if (pill.keyboardNav)
                        root.keyboardMon = "";
                }

                ThePill {
                    id: pill
                    anchors.top: parent.top
                    anchors.topMargin: overlay.mVert
                    anchors.horizontalCenter: parent.horizontalCenter
                    s: overlay.s
                    screenName: overlay.modelData.name
                    barWindow: overlay
                    surface: overlay.surface
                    keyboardNav: overlay.keyboardNav

                    opacity: overlay.monFullscreen ? 0 : pill.swipeFade
                    Behavior on opacity {
                        NumberAnimation {
                            duration: Motion.morph
                            easing.type: Motion.easeMorph
                            easing.bezierCurve: Motion.morphCurve
                        }
                    }
                    transform: [
                        Translate {
                            x: pill.swipeX
                            y: pill.swipeY
                        },
                        Translate {
                            y: overlay.monFullscreen ? -(pill.height + overlay.mVert) : 0
                            Behavior on y {
                                NumberAnimation {
                                    duration: Motion.morph
                                    easing.type: Motion.easeMorph
                                    easing.bezierCurve: Motion.morphCurve
                                }
                            }
                        }
                    ]

                    onRequestSurface: (name) => root.toggleSurface(overlay.modelData.name, name)
                    onRequestClose: root.close()
                }
            }

            onSurfaceOpenChanged: if (surfaceOpen) focusScope.forceActiveFocus()
            onKeyboardNavChanged: if (keyboardNav) focusScope.forceActiveFocus()
        }
    }

    Variants {
        model: Quickshell.screens

        NotifCorner {}
    }
}
