import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "_Shared/Singletons"
import "_Shared/Components"

Item {
    id: root
    property string currentMonitor: ""
    property bool isPrimaryScreen: currentMonitor === "DP-2"

    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight

    property var activeRing: container.children.find(child => child.isActive)

    readonly property point heroPoint: {
        void root.width;
        void root.height;
        return container.children[0].mapToItem(root, container.children[0].width / 2, container.children[0].height / 2);
    }

    // property string ameForm: "rest"
    property string ameForm: container.children.some(child => child.isFocused) ? "rest" : "soul"
    property real ameS: ameForm === "soul" ? 1.2 : 1
    property point amePoint: activeRing ? Qt.point(root.activeRing.x + root.activeRing.width / 2, root.activeRing.y + root.activeRing.height / 2) : heroPoint

    RowLayout {
        id: container
        spacing: 12

        Repeater {
            model: 5

            delegate: Rectangle {
                id: workspaceRing

                property int workspaceId: root.isPrimaryScreen ? (index * 2 + 1) : (index * 2 + 2)

                property var workspace: Hyprland.workspaces.values.find(w => w.id === workspaceRing.workspaceId)

                property bool exists: workspace !== undefined
                property bool isFocused: exists && workspace.focused
                property bool isActive: exists && workspace.active

                implicitWidth: 4
                implicitHeight: 4
                radius: width / 2

                // color: isFocused ? Theme.colour.accent : (isActive ? Theme.colour.accentMuted : Theme.colour.foregroundMuted)
                color: Theme.colour.foregroundMuted

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: -1
                    radius: width / 2
                    color: exists ? parent.color : "transparent"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: workspaceRing.workspace.activate()
                }
            }
        }
    }
}
