import Quickshell
import QtQuick
import QtQuick.Layouts
import "_Shared"

Item {
    id: root

    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight

    property bool isCollapsed: false

    property string icon: MprisState.isPlaying ? "󰎇" : "󰽴"

    MouseArea {
        anchors.fill: parent
        anchors.topMargin: -10
        anchors.bottomMargin: -10
        anchors.leftMargin: -10
        anchors.rightMargin: -10

        onClicked: root.isCollapsed = !root.isCollapsed
    }

    RowLayout {
        id: container
        anchors.fill: parent
        spacing: 8

        ThemedText {
            text: root.icon
        }

        Item {
            id: titleContainer

            visible: !root.isCollapsed || hideAnimation.running
            clip: true

            implicitWidth: root.isCollapsed ? 0 : titleText.implicitWidth
            implicitHeight: titleText.implicitHeight

            Behavior on implicitWidth {
                NumberAnimation {
                    id: hideAnimation
                    duration: Motion.morph
                    easing.type: Motion.easeMorph
                    easing.bezierCurve: Motion.morphCurve

                    // TODO: This results in a jump at the end, but not setting visible = false leaves spacing on the right
                    onStopped: {
                        if (root.isCollapsed) {
                            titleContainer.visible = false
                        }
                    }
                }
            }

            ThemedText {
                id: titleText
                text: MprisState.artistAndTitle || "No Media Playing"
                elide: Text.ElideRight
                maximumLineCount: 1
                width: 300
            }
        }
    }
}
