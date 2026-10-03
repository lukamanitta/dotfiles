pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Services.Notifications
import "../Singletons"

/**
 * Notification avatar: the notification's image when it resolves, otherwise a
 * rotated-diamond placeholder. The placeholder is always the accent colour so
 * the card, toast and inbox agree (they used to disagree between muted and
 * accent).
 */
Item {
    id: root

    property real s: 1
    required property var notif
    property real size: 32 * s

    implicitWidth: size
    implicitHeight: size

    Rectangle {
        anchors.fill: parent
        radius: root.size * 0.3
        color: Theme.colour.surfaceOverlay
        border.width: 1
        border.color: Theme.colour.border
    }

    Image {
        id: img
        anchors.fill: parent
        anchors.margins: (root.notif && root.notif.image) ? 0 : root.size * 0.18
        source: Notifs.iconFor(root.notif)
        sourceSize.width: Math.round(root.size * 2)
        sourceSize.height: Math.round(root.size * 2)
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: source.toString().length > 0
    }

    Rectangle {
        anchors.centerIn: parent
        visible: !img.visible
        width: root.size * 0.3
        height: root.size * 0.3
        radius: root.size * 0.08
        rotation: 45
        color: Theme.colour.accent
    }
}
