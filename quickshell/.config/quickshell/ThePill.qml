pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import Quickshell
import "_Shared/Components"
import "_Shared/Singletons"

Item {
    id: pill

    property real s: 1
    property string screenName: ""
    property var barWindow
    property string surface: ""

    property bool hovered: false
    property bool pinned: false

    readonly property bool held: pinned
    readonly property bool launcherOpen: surface === "launcher"
    readonly property bool powerOpen: surface === "power"

    readonly property bool surfaceOpen: surface.length > 0
    property bool hoverLatch: false
    readonly property bool expanded: surfaceOpen || hoverLatch || held

    readonly property real restPad: 8 * s
    readonly property real restW: 120 * s
    readonly property real restH: 38 * s
    readonly property real hoverPad: 20 * s
    readonly property real hoverW: hoverRow.implicitWidth + (hoverPad * 2)
    readonly property real hoverH: 58 * s

    readonly property real launcherW: 360 * s
    readonly property real launcherH: 332 * s
    readonly property real powerW: 330 * s
    readonly property real powerH: 150 * s

    readonly property real restCornerRadius: 18 * s
    readonly property real openCornerRadius: 22 * s

    readonly property string mode: {
        if (launcherOpen)
            return "launcher";
        if (powerOpen)
            return "power";
        return expanded ? "hover" : "rest";
    }

    signal requestSurface(string name)
    signal requestClose()

    onSurfaceOpenChanged: if (surfaceOpen) pinned = false

    property real morphRadius: (mode === "rest" || mode === "hover") ? restCornerRadius : openCornerRadius

    readonly property var surfaceSize: ({
            launcher: () => Qt.size(launcherW, launcherH),
            power: () => Qt.size(powerW, powerH),
            hover: () => Qt.size(hoverW, hoverH)
        })

    readonly property size targetSize: {
        const f = surfaceSize[mode];
        return f ? f() : Qt.size(Math.max(restW, restRow.implicitWidth + (restPad * 2) * s), restH);
    }
    readonly property real targetW: targetSize.width
    readonly property real targetH: targetSize.height

    width: targetW
    height: targetH

    readonly property real morphCloseness: {
        const d = Math.max(Math.abs(width - targetW), Math.abs(height - targetH));
        return 1 - Math.min(1, d / (110 * s));
    }

    // Soul bead gate (wait until hover morph is complete before allowing it to move)
    property bool hoverSoulGate: false
    readonly property bool hoverArrived: mode === "hover" && morphCloseness > 0.55
    onHoverArrivedChanged: if (hoverArrived) hoverSoulGate = true
    onModeChanged: if (mode !== "hover") {
        hoverSoulGate = false;
        soulTarget = "";
    }
    onHoverSoulGateChanged: if (hoverSoulGate) heroFlashAnim.restart()

    property string soulTarget: ""
    property real heroFlash: 0

    SequentialAnimation {
        id: heroFlashAnim
        NumberAnimation {
            target: pill
            property: "heroFlash"
            to: 1
            duration: 90
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: pill
            property: "heroFlash"
            to: 0
            duration: 320
            easing.type: Easing.OutCubic
        }
    }

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
    Behavior on morphRadius {
        NumberAnimation {
            duration: Motion.morph
            easing.type: Motion.easeMorph
            easing.bezierCurve: Motion.morphCurve
        }
    }

    Rectangle {
        id: body
        anchors.fill: parent
        radius: pill.morphRadius
        border.width: 1
        border.color: "transparent"
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
            shadowVerticalOffset: 3 * pill.s
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

    // Rest anchor for bead / Ame
    readonly property point wakePoint: {
        void pill.width;
        void pill.height;
        return restHero.mapToItem(pill, restHero.width / 2, restHero.height / 2);
    }

    // Bead target while hovered
    readonly property point soulPoint: {
        void pill.width;
        void pill.height;
        const drop = 12 * pill.s;
        if (soulTarget === "inbox")
            return inboxIcon.mapToItem(pill, inboxIcon.width / 2, inboxIcon.height / 2 + drop);
        if (soulTarget === "power")
            return powerIcon.mapToItem(pill, powerIcon.width / 2, powerIcon.height / 2 + drop);
        return hoverHero.mapToItem(pill, hoverHero.width / 2, hoverHero.height / 2);
    }

    // Which open surface owns the bead's anchor
    readonly property var ameSurface: {
        if (launcherOpen)
            return launcher;
        if (powerOpen)
            return power;
        return null;
    }

    Ame {
        id: ame
        anchors.fill: parent
        s: pill.s
        heat: pill.powerOpen ? power.holdProgress : 0
        wake: pill.wakePoint
        wickDir: pill.powerOpen ? 1 : -1
        form: pill.ameSurface ? pill.ameSurface.ameForm : (pill.mode === "hover" && pill.hoverSoulGate ? "soul" : "off")
        point: pill.ameSurface ? Qt.point(pill.ameSurface.x + pill.ameSurface.amePoint.x, pill.ameSurface.y + pill.ameSurface.amePoint.y) : (pill.mode === "hover" ? pill.soulPoint : pill.wakePoint)
    }

    onHoveredChanged: {
        if (hovered) {
            hoverLatch = true;
            graceTimer.stop();
        } else {
            graceTimer.restart();
        }
    }

    Timer {
        id: graceTimer
        interval: 300
        onTriggered: {
            if (pill.morphCloseness < 0.95) {
                graceTimer.restart();
                return;
            }
            pill.hoverLatch = false;
        }
    }

    TapHandler {
        enabled: !pill.surfaceOpen
        gesturePolicy: TapHandler.WithinBounds
        onTapped: pill.pinned = !pill.pinned
    }

    Item {
        id: rest
        anchors.fill: parent
        opacity: (pill.expanded || pill.mode === "toast") ? 0 : Math.pow(pill.morphCloseness, 1.5)
        visible: opacity > 0.01
        Behavior on opacity {
            NumberAnimation {
                duration: pill.mode === "rest" ? Motion.fast : 260
            }
        }

        Row {
            id: restRow
            anchors.centerIn: parent
            spacing: 12 * pill.s
            Item {
                id: restHero
                anchors.verticalCenter: parent.verticalCenter
                width: heroFill.implicitWidth
                height: heroFill.implicitHeight

                AudioIndicator {
                    id: heroFill
                    anchors.verticalCenter: parent.verticalCenter
                    width: 17 * pill.s
                    height: 17 * pill.s
                    isAudioPlaying: MprisState.isPlaying
                }

                // Text {
                //     id: heroFill
                //     anchors.verticalCenter: parent.verticalCenter
                //     text: ""
                //     color: Theme.colour.foregroundDefault
                //     font.family: "Symbols Nerd Font"
                //     font.pixelSize: Theme.fontSizeXLarge * pill.s
                // }
                //
                // MultiEffect {
                //     source: heroFill
                //     anchors.fill: heroFill
                //     shadowEnabled: true
                //     shadowColor: Qt.alpha(Theme.colour.vermLit, Math.min(1, (pill.mode === "rest" || !pill.hoverSoulGate ? 0.5 : 0) + pill.heroFlash))
                //     shadowBlur: 0.3
                //     shadowVerticalOffset: 0
                //     shadowHorizontalOffset: 0
                // }
            }
            ThemedText {
                anchors.verticalCenter: parent.verticalCenter
                text: DateTime.time
                font.pixelSize: Theme.fontSizeLarge * pill.s
                font.weight: Font.Bold
                font.features: {
                    "tnum": 1
                }
            }
        }
    }

    Item {
        id: hover
        anchors.fill: parent
        opacity: pill.mode === "hover" ? Math.pow(pill.morphCloseness, 1.2) : 0
        visible: true
        Behavior on opacity {
            NumberAnimation {
                duration: pill.mode === "hover" ? Motion.fast : 40
            }
        }

        readonly property bool live: pill.mode === "hover"

        Row {
            id: hoverRow
            anchors.centerIn: parent
            spacing: 20 * pill.s

            Item {
                id: hoverHero
                anchors.verticalCenter: parent.verticalCenter
                width: hoverHeroFill.implicitWidth
                height: hoverHeroFill.implicitHeight

                AudioIndicator {
                    id: hoverHeroFill
                    anchors.verticalCenter: parent.verticalCenter
                    width: 17 * pill.s
                    height: 17 * pill.s
                    isAudioPlaying: MprisState.isPlaying
                }

                // Text {
                //     id: hoverHeroFill
                //     anchors.verticalCenter: parent.verticalCenter
                //     text: ""
                //     color: Theme.colour.foregroundDefault
                //     font.family: "Symbols Nerd Font"
                //     font.pixelSize: Theme.fontSizeXLarge * pill.s
                // }
                //
                // MultiEffect {
                //     source: hoverHeroFill
                //     anchors.fill: hoverHeroFill
                //     shadowEnabled: true
                //     shadowColor: Qt.alpha(Theme.colour.vermLit, Math.min(1, (pill.mode === "rest" || !pill.hoverSoulGate ? 0.5 : 0) + pill.heroFlash))
                //     shadowBlur: 0.3
                //     shadowVerticalOffset: 0
                //     shadowHorizontalOffset: 0
                // }
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 1
                height: 22 * pill.s
                color: Theme.colour.foregroundMuted
            }

            Item {
                anchors.verticalCenter: parent.verticalCenter
                width: hoverClock.implicitWidth
                height: hoverClock.implicitHeight

                ClockWidget {
                    id: hoverClock
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.centerIn: parent
                    width: hoverClock.implicitWidth + 22 * pill.s
                    height: hoverClock.implicitHeight + 10 * pill.s
                    enabled: hover.live
                    cursorShape: Qt.PointingHandCursor
                    onClicked: pill.requestSurface("calendar")
                }
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 1
                height: 22 * pill.s
                color: Theme.colour.foregroundMuted
            }

            Row {
                id: actionsRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12 * pill.s

                // MinimisedTray {
                //     id: minimised
                //     anchors.verticalCenter: parent.verticalCenter
                //     s: pill.s
                //     screenName: pill.screenName
                //     enabled: hover.live
                //     visible: count > 0
                // }
                //
                // Rectangle {
                //     anchors.verticalCenter: parent.verticalCenter
                //     width: 1
                //     height: 14 * pill.s
                //     color: Theme.colour.foregroundMuted
                //     opacity: 0.7
                // }
                //
                // Tray {
                //     anchors.verticalCenter: parent.verticalCenter
                //     s: pill.s
                //     barWindow: pill.barWindow
                //     enabled: hover.live
                // }

                Item {
                    id: inboxIcon
                    anchors.verticalCenter: parent.verticalCenter
                    width: 17 * pill.s
                    height: 17 * pill.s

                    Text {
                        anchors.fill: parent
                        text: ""
                        font.family: "Symbols Nerd Font"
                        font.pixelSize: 17 * pill.s
                        color: inboxArea.containsMouse ? Theme.colour.foregroundDefault : Theme.colour.foregroundMuted
                    }

                    Rectangle {
                        // visible: Notifs.unread > 0
                        visible: false
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.topMargin: -2 * pill.s
                        anchors.rightMargin: -2 * pill.s
                        width: 5 * pill.s
                        height: 5 * pill.s
                        radius: width / 2
                        color: Theme.colour.accent
                    }

                    MouseArea {
                        id: inboxArea
                        anchors.fill: parent
                        anchors.margins: -6 * pill.s
                        hoverEnabled: true
                        enabled: hover.live
                        cursorShape: Qt.PointingHandCursor
                        onClicked: pill.requestSurface("link")
                        onContainsMouseChanged: if (containsMouse)
                            pill.soulTarget = "inbox"
                    }
                }

                Item {
                    id: powerIcon
                    anchors.verticalCenter: parent.verticalCenter
                    width: 17 * pill.s
                    height: 17 * pill.s

                    Text {
                        anchors.fill: parent
                        text: "󰐥"
                        font.family: "Symbols Nerd Font"
                        font.pixelSize: 17 * pill.s
                        color: powerArea.containsMouse ? Theme.colour.foregroundDefault : Theme.colour.foregroundMuted
                    }

                    MouseArea {
                        id: powerArea
                        anchors.fill: parent
                        anchors.margins: -6 * pill.s
                        hoverEnabled: true
                        enabled: hover.live
                        cursorShape: Qt.PointingHandCursor
                        onClicked: pill.requestSurface("power")
                        onContainsMouseChanged: if (containsMouse)
                            pill.soulTarget = "power"
                    }
                }
            }
        }
    }
    // ThePillLauncher {
    //     id: launcher
    //     s: pill.s
    //     open: pill.launcherOpen
    //     morphCloseness: pill.morphCloseness
    //     onRequestClose: pill.requestClose()
    // }

    ThePillPower {
        id: power
        s: pill.s
        open: pill.powerOpen
        morphCloseness: pill.morphCloseness
        onRequestClose: pill.requestClose()
    }
}
