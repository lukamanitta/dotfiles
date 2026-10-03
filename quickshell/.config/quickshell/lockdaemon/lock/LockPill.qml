pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import "../_Shared/Components"
import "../_Shared/Singletons"

/**
 * The lock's password field, wearing the ThePill body: the same gradient
 * surface, hairline sheen and soft drop shadow. One bead per typed character
 * (the freshest burns brightest), an eye toggle and a shake on a rejected
 * password. On success `collapsing` flips and the field morphs down to the
 * resting pill footprint so it can hand off to the real pill at the top.
 */
Item {
    id: root

    property real s: 1
    property var auth: null
    property bool active: false
    /** Set by the surface once auth succeeds: morph into the rest pill. */
    property bool collapsing: false

    readonly property bool authenticating: auth ? auth.authenticating : false
    property bool showError: false
    property bool reveal: false

    readonly property real pad: 17 * s
    readonly property real fullW: 348 * s
    readonly property real fullH: 46 * s
    readonly property real restW: 120 * s
    readonly property real restH: 34 * s

    width: collapsing ? restW : fullW
    height: collapsing ? restH : fullH
    property real radius: collapsing ? 18 * s : height / 2

    Behavior on width {
        NumberAnimation {
            duration: Motion.morph
            easing.type: Motion.easeMorph
            easing.bezierCurve: Motion.morphCurve
        }
    }
    Behavior on height {
        NumberAnimation {
            duration: Motion.morph
            easing.type: Motion.easeMorph
            easing.bezierCurve: Motion.morphCurve
        }
    }
    Behavior on radius {
        NumberAnimation {
            duration: Motion.morph
            easing.type: Motion.easeMorph
            easing.bezierCurve: Motion.morphCurve
        }
    }

    Connections {
        target: root.auth
        enabled: root.auth !== null
        function onFailed() {
            root.showError = true;
            root.reveal = false;
            input.text = "";
            shake.restart();
        }
        function onSucceeded() {
            root.showError = false;
            root.reveal = false;
            input.text = "";
        }
    }

    onActiveChanged: {
        if (active) {
            showError = false;
            reveal = false;
            input.text = "";
            Qt.callLater(function () {
                input.forceActiveFocus();
            });
        }
    }

    Component.onCompleted: if (active)
        Qt.callLater(function () {
            input.forceActiveFocus();
        })

    Rectangle {
        id: body
        anchors.fill: parent
        radius: root.radius
        border.width: 1
        border.color: root.showError
            ? Qt.alpha(Theme.colour.critical, 0.65)
            : (input.activeFocus ? Qt.alpha(Theme.colour.foregroundSubtle, 0.35) : "transparent")
        gradient: Gradient {
            GradientStop {
                position: 0
                color: Theme.colour.surfaceLight
            }
            GradientStop {
                position: 1
                color: Theme.colour.surfaceDefault
            }
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, Theme.shadowOpacity)
            shadowBlur: 0.7
            shadowVerticalOffset: 3 * root.s
        }

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 1
            anchors.leftMargin: body.radius * 0.6
            anchors.rightMargin: body.radius * 0.6
            height: 1
            color: Theme.sheen
        }
    }

    Item {
        id: content
        anchors.fill: parent
        opacity: root.collapsing ? 0 : 1
        Behavior on opacity {
            NumberAnimation {
                duration: 180
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.IBeamCursor
            onClicked: input.forceActiveFocus()
        }

        GlyphIcon {
            id: lockGlyph
            anchors.left: parent.left
            anchors.leftMargin: root.pad
            anchors.verticalCenter: parent.verticalCenter
            width: 16 * root.s
            height: 16 * root.s
            name: "lock"
            stroke: 1.8 * root.s
            color: root.showError ? Theme.colour.critical : Theme.colour.foregroundSubtle
        }

        /**
         * The typing region between the lock glyph and the eye. Clipped so a
         * password longer than the field can never spill over the glyphs, and
         * the beads/placeholder stay bounded on both axes.
         */
        Item {
            id: fieldRegion
            anchors.left: lockGlyph.right
            anchors.right: eye.left
            anchors.leftMargin: 12 * root.s
            anchors.rightMargin: 10 * root.s
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            clip: true

            TextInput {
                id: input
                anchors.fill: parent
                verticalAlignment: TextInput.AlignVCenter
                horizontalAlignment: TextInput.AlignHCenter
                echoMode: TextInput.Normal
                color: root.reveal ? Theme.colour.foregroundDefault : "transparent"
                selectionColor: Theme.colour.accent
                selectedTextColor: Theme.colour.surfaceDefault
                font.family: Theme.fontFamily
                font.pixelSize: 15 * root.s
                font.letterSpacing: root.reveal ? 2 * root.s : 0
                clip: true
                focus: true
                enabled: root.active && !root.authenticating && !root.collapsing
                onTextChanged: {
                    if (text.length > 0)
                        root.showError = false;
                }
                onAccepted: {
                    if (root.auth && text.length > 0)
                        root.auth.submit(text);
                }

                cursorDelegate: Rectangle {
                    visible: root.reveal && input.text.length > 0
                    width: 2 * root.s
                    height: input.cursorRectangle.height
                    color: Theme.colour.vermLit
                }
            }

            Row {
                anchors.centerIn: parent
                spacing: 9 * root.s
                visible: !root.reveal && input.text.length > 0

                Repeater {
                    model: input.text.length
                    delegate: Rectangle {
                        id: bead
                        required property int index
                        width: 7 * root.s
                        height: width
                        radius: width / 2
                        color: bead.index === input.text.length - 1 ? Theme.colour.vermLit : Theme.colour.foregroundMuted
                        scale: 0
                        Component.onCompleted: pop.start()
                        NumberAnimation {
                            id: pop
                            target: bead
                            property: "scale"
                            to: 1
                            duration: 170
                            easing.type: Easing.OutBack
                        }
                    }
                }
            }

            ThemedText {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                visible: input.text.length === 0
                text: {
                    if (root.showError) {
                        var msg = root.auth ? root.auth.lastError : "";
                        return msg.length > 0 ? msg.toLowerCase() : "wrong password";
                    }
                    return root.authenticating ? "authenticating..." : "enter password";
                }
                color: root.showError ? Theme.colour.critical : Theme.colour.foregroundMuted
                font.pixelSize: 14 * root.s
                font.letterSpacing: 1 * root.s
            }
        }

        GlyphIcon {
            id: eye
            anchors.right: parent.right
            anchors.rightMargin: root.pad
            anchors.verticalCenter: parent.verticalCenter
            width: 18 * root.s
            height: 18 * root.s
            name: root.reveal ? "eye-off" : "eye"
            color: eyeArea.containsMouse ? Theme.colour.foregroundDefault : Theme.colour.foregroundMuted
            stroke: 1.8

            MouseArea {
                id: eyeArea
                anchors.fill: parent
                anchors.margins: -6 * root.s
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.reveal = !root.reveal
            }
        }
    }

    transform: Translate { id: shift }

    SequentialAnimation {
        id: shake
        NumberAnimation { target: shift; property: "x"; to: 9 * root.s; duration: 50 }
        NumberAnimation { target: shift; property: "x"; to: -9 * root.s; duration: 50 }
        NumberAnimation { target: shift; property: "x"; to: 6 * root.s; duration: 50 }
        NumberAnimation { target: shift; property: "x"; to: -6 * root.s; duration: 50 }
        NumberAnimation { target: shift; property: "x"; to: 0; duration: 50 }
    }
}
