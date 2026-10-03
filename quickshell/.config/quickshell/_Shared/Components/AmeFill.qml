pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Widgets
import "../Singletons"

/**
 * Reusable "Ame target" button: a pill with an immediate hover state and an
 * accent fill that grows in from the bottom when `filled` is set — typically
 * the moment the Ame bead finishes travelling to and docking at it. The bead
 * itself is owned by the host (so one bead can serve many targets); this only
 * carries the visuals, making it reusable for any hoverable/holdable element
 * (notification Open, inbox rows, future settings toggles…).
 */
Rectangle {
    id: root

    property real s: 1
    property string text: ""
    /** Set by the host once its Ame has arrived; drives the accent fill. */
    property bool filled: false
    /** Immediate pointer state. */
    readonly property bool hovered: hoverArea.containsMouse

    signal clicked()

    implicitWidth: label.implicitWidth + 22 * s
    implicitHeight: 24 * s
    radius: implicitHeight / 2
    color: root.filled ? Theme.colour.accentMuted : Theme.colour.surfaceOverlay
    border.width: 1
    border.color: (root.hovered || root.filled) ? Theme.colour.accent : Theme.colour.border
    Behavior on color { ColorAnimation { duration: Motion.fast } }

    ClippingRectangle {
        anchors.fill: parent
        anchors.margins: 1
        radius: root.radius - 1
        color: "transparent"

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: root.filled ? parent.height : 0
            gradient: Gradient {
                GradientStop { position: 0; color: Theme.colour.accent }
                GradientStop { position: 1; color: Theme.colour.accentMuted }
            }
            Behavior on height {
                NumberAnimation {
                    duration: Motion.standard
                    easing.type: Motion.easeStandard
                }
            }
        }
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: root.text
        color: root.filled ? Theme.colour.surfaceDefault : (root.hovered ? Theme.colour.accent : Theme.colour.foregroundSubtle)
        font.family: Theme.font
        font.pixelSize: 12 * root.s
        font.weight: Font.DemiBold
        Behavior on color { ColorAnimation { duration: Motion.fast } }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
