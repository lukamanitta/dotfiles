pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Services.Notifications
import "../Singletons"

/**
 * Shared notification card content: icon tile, app eyebrow, summary with a
 * critical ember, optional body text, action pills and a dismiss glyph. Draws
 * no background of its own so both hosts (the pill-morph Toast and the corner
 * stack) can supply their own material while keeping the inner content
 * identical. The card owns an Ame bead that rests beside the icon (rowseam)
 * and travels to the Open button when it is hovered, filling it with accent.
 */
Item {
    id: root

    property real s: 1
    required property var notif
    /** When true the summary/body wrap in full instead of being truncated. */
    property bool expanded: false

    readonly property bool critical: notif.urgency === NotificationUrgency.Critical
    readonly property var acts: (notif.actions || []).filter(function(a) { return a.text.length > 0; })
    /** The action button under the pointer; the Ame docks and fills it. */
    readonly property Item actionHover: (muteBtn && muteBtn.hovered) ? muteBtn : ((openBtn && openBtn.hovered) ? openBtn : null)
    /** Latched once the Ame is closing on the hovered action; drives the fill. */
    property bool actionFilled: false
    readonly property string app: (notif.appName && notif.appName.length) ? notif.appName : "System"
    readonly property bool muted: Notifs.isMuted(root.app)

    signal activate()
    signal dismiss()
    signal actionInvoked(var action)
    signal muteToggled()

    implicitHeight: Math.max(iconTile.height, col.implicitHeight)

    NotifIcon {
        id: iconTile
        anchors.left: parent.left
        anchors.leftMargin: 8 * root.s
        anchors.top: parent.top
        s: root.s
        size: 22 * root.s
        notif: root.notif
    }

    GlyphIcon {
        id: dismiss
        anchors.top: parent.top
        anchors.right: parent.right
        width: 13 * root.s
        height: 13 * root.s
        name: "close"
        color: dismissArea.containsMouse ? Theme.colour.foregroundDefault : Theme.colour.foregroundSubtle
        stroke: 1.9

        Behavior on color {
            ColorAnimation { duration: Motion.fast }
        }

        MouseArea {
            id: dismissArea
            anchors.fill: parent
            anchors.margins: -8 * root.s
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.dismiss()
        }
    }

    /**
     * Ame rests beside the icon as an inbox-style rowseam and docks at whichever
     * action button is hovered. Declared before the content column so it sits
     * behind the button (which fills with accent as the bead arrives).
     */
    Ame {
        id: cardAme
        anchors.fill: parent
        s: root.s
        form: root.actionHover ? "dock" : "rowseam"
        point: root.actionHover
            ? root.actionHover.mapToItem(root, root.actionHover.width / 2, root.actionHover.height / 2)
            : Qt.point(4 * root.s, iconTile.height / 2)
        wake: point
        heat: 0
        wickDir: -1
    }

    onActionHoverChanged: if (actionHover) actionFilled = false

    Connections {
        target: cardAme
        function onArrivingChanged() {
            if (cardAme.arriving && root.actionHover)
                root.actionFilled = true;
        }
    }

    Column {
        id: col
        anchors.left: iconTile.right
        anchors.leftMargin: 12 * root.s
        anchors.right: dismiss.left
        anchors.rightMargin: 10 * root.s
        anchors.top: parent.top
        spacing: 3 * root.s

        Text {
            width: parent.width
            text: (root.notif.appName && root.notif.appName.length) ? root.notif.appName : "System"
            color: Theme.colour.foregroundMuted
            font.family: Theme.font
            font.pixelSize: 10 * root.s
            font.weight: Font.DemiBold
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 1.4 * root.s
            elide: Text.ElideRight
            textFormat: Text.PlainText
        }

        Row {
            width: parent.width
            spacing: 6 * root.s

            Item {
                visible: root.critical
                anchors.verticalCenter: parent.verticalCenter
                width: 9 * root.s
                height: 9 * root.s

                Rectangle {
                    anchors.centerIn: parent
                    width: 9 * root.s
                    height: 9 * root.s
                    radius: 999
                    color: Theme.colour.critical
                    opacity: 0.3
                }
                Rectangle {
                    anchors.centerIn: parent
                    width: 4.5 * root.s
                    height: 4.5 * root.s
                    radius: 999
                    color: Theme.colour.critical
                }
            }

            Text {
                width: parent.width - (root.critical ? 15 * root.s : 0)
                text: root.notif.summary
                color: Theme.colour.foregroundDefault
                font.family: Theme.font
                font.pixelSize: 15 * root.s
                font.weight: Font.DemiBold
                wrapMode: root.expanded ? Text.Wrap : Text.NoWrap
                maximumLineCount: root.expanded ? 1000 : 1
                elide: root.expanded ? Text.ElideNone : Text.ElideRight
                textFormat: Text.PlainText
            }
        }

        Text {
            width: parent.width
            visible: root.notif.body.length > 0
            text: root.notif.body
            color: Theme.colour.foregroundSubtle
            font.family: Theme.font
            font.pixelSize: 13 * root.s
            wrapMode: Text.Wrap
            maximumLineCount: root.expanded ? 1000 : 2
            elide: root.expanded ? Text.ElideNone : Text.ElideRight
            textFormat: Text.PlainText
        }

        Row {
            visible: root.acts.length > 0
            spacing: 6 * root.s
            topPadding: 5 * root.s

            Repeater {
                model: root.acts

                Rectangle {
                    id: actPill
                    required property var modelData
                    required property int index

                    height: 24 * root.s
                    width: actText.implicitWidth + 22 * root.s
                    radius: 999
                    color: Theme.colour.surfaceOverlay
                    border.width: 1
                    border.color: Theme.colour.border

                    Text {
                        id: actText
                        anchors.centerIn: parent
                        text: actPill.modelData.text
                        color: actPill.index === 0 ? Theme.colour.accent : Theme.colour.foregroundSubtle
                        font.family: Theme.font
                        font.pixelSize: 12 * root.s
                        font.weight: Font.DemiBold
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.actionInvoked(actPill.modelData)
                    }
                }
            }
        }

        Item {
            visible: root.expanded
            width: 1
            height: 4 * root.s
        }

        Item {
            visible: root.expanded
            width: parent.width
            height: openBtn.implicitHeight

            AmeFill {
                id: openBtn
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                s: root.s
                text: "Open"
                filled: root.actionHover === openBtn && root.actionFilled
                onClicked: root.activate()
            }

            AmeFill {
                id: muteBtn
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                s: root.s
                text: root.muted ? "Unmute" : "Mute 30m"
                filled: root.muted || (root.actionHover === muteBtn && root.actionFilled)
                onClicked: root.muteToggled()
            }
        }
    }
}
