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

    function refresh() {
        Hyprland.refreshMonitors();
        Hyprland.refreshWorkspaces();
        Hyprland.refreshTopLevels();
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
        }
    }

    function toggleSurface(mon, surface) {
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

    IpcHandler {
        target: "pill"
        function launcher(mon: string): void { root.toggleSurface(mon, "launcher"); }
        function power(mon: string): void { root.toggleSurface(mon, "power"); }
        function hide(): void { root.close(); }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: reserve
            required property var modelData
            readonly property real s: modelData ? modelData.height / 1080 : 1
            readonly property real mVert: 8 * s
            readonly property real restHeight: 38 * s

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
            readonly property real mVert: 8 * s
            readonly property string surface: root.openMon === modelData.name ? root.openSurface : ""
            readonly property bool surfaceOpen: surface.length > 0
            readonly property bool modal: surfaceOpen || pill.held

            readonly property bool monFullscreen: {
                var mons = Hyprland.monitors.values;
                for (var i = 0; i < mons.length; i++) {
                    if (mons[i].name === modelData.name) {
                        var ws = mons[i].activeWorkspace;
                        // var o = ws ? ws.lastIpcObject : null;
                        var o = ws;
                        return o ? !!o.hasFullscreen : false;
                    }
                }
                return false;
            }

            onMonFullscreenChanged: if (monFullscreen) {
                if (root.openMon === modelData.name) root.close();
                pill.pinned = false;
            }

            screen: modelData
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay

            // Doesn't work -
            // https://github.com/AvengeMedia/DankMaterialShell/issues/2561
            // https://github.com/hyprwm/Hyprland/discussions/13116
            // WlrLayershell.keyboardFocus: surfaceOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

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
                focus: overlay.surfaceOpen

                HoverHandler {
                    onHoveredChanged: {
                        pill.hovered = hovered
                    }
                }
                Keys.onEscapePressed: root.close()

                ThePill {
                    id: pill
                    anchors.top: parent.top
                    anchors.topMargin: overlay.mVert
                    anchors.horizontalCenter: parent.horizontalCenter
                    s: overlay.s
                    screenName: overlay.modelData.name
                    barWindow: overlay
                    surface: overlay.surface

                    opacity: overlay.monFullscreen ? 0 : 1
                    Behavior on opacity {
                        NumberAnimation {
                            duration: Motion.morph
                            easing.type: Motion.easeMorph
                            easing.bezierCurve: Motion.morphCurve
                        }
                    }
                    transform: Translate {
                        y: overlay.monFullscreen ? -(pill.height + overlay.mVert) : 0
                        Behavior on y {
                            NumberAnimation {
                                duration: Motion.morph
                                easing.type: Motion.easeMorph
                                easing.bezierCurve: Motion.morphCurve
                            }
                        }
                    }

                    onRequestSurface: (name) => root.toggleSurface(overlay.modelData.name, name)
                    onRequestClose: root.close()
                }
            }

            onSurfaceOpenChanged: if (surfaceOpen) focusScope.forceActiveFocus()
        }
    }
}
