import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "_Shared"

RowLayout {
    id: root
    spacing: 8

    property string currentMonitor: ""

    property bool isPrimaryScreen: currentMonitor === "DP-2"

    Repeater {
        model: 5

        delegate: Rectangle {
            id: workspaceDot

            property int workspaceId: root.isPrimaryScreen ? (index * 2 + 1) : (index * 2 + 2)

            property var workspace: Hyprland.workspaces.values.find(w => w.id === workspaceDot.workspaceId)

            property bool exists: workspace !== undefined
            property bool isFocused: exists && workspace.focused
            property bool isActive: exists && workspace.active

            implicitWidth: 14
            implicitHeight: 14
            radius: width / 2

            color: isFocused ? Theme.colour.accent : (isActive ? Theme.colour.accentMuted : (exists ? Theme.colour.foregroundMuted : "#3b3b3b"))

            border.width: (exists && !isFocused) ? 1 : 0
            border.color: "#d8dee9"

            MouseArea {
                anchors.fill: parent
                onClicked: workspaceDot.workspace.activate()
            }
        }
    }
}
