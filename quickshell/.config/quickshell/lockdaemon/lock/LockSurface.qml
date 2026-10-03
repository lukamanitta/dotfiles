pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Quickshell
import "../_Shared/Components"
import "../_Shared/Singletons"

/**
 * One per output. Shows the current wallpaper blurred and dimmed, and on the
 * primary output a centred column of date, clock and the pill-shaped password
 * field beneath them. When auth succeeds the field morphs up to the resting
 * pill spot at the top (handing off to the real pill) as the lock releases.
 */
Item {
    id: surface

    property real s: 1
    property var auth: null
    property string screenName: ""
    property string wallpaperSource: ""
    property bool active: false
    property bool unlocking: false

    readonly property bool isMain: {
        var scr = Quickshell.screens;
        if (scr.length === 0)
            return true;
        return surface.screenName === scr[0].name;
    }

    readonly property string dateText: {
        void DateTime.time;
        return Qt.formatDateTime(new Date(), "dddd, d MMMM");
    }

    readonly property real pillGap: 24 * s
    readonly property real restFieldH: 46 * s
    readonly property real topGap: 6 * s

    property bool shown: false

    opacity: shown ? 1 : 0
    Behavior on opacity {
        NumberAnimation {
            duration: 240
            easing.type: Easing.OutCubic
        }
    }

    Component.onCompleted: shownTimer.start()
    onActiveChanged: if (active)
        shownTimer.restart()

    Timer {
        id: shownTimer
        interval: 30
        onTriggered: surface.shown = true
    }

    // Fallback if the wallpaper is missing, so the surface is never a
    // transparent hole onto the live desktop.
    Rectangle {
        anchors.fill: parent
        color: Theme.colour.surfaceDefault
    }

    Image {
        id: bg
        anchors.fill: parent
        source: surface.wallpaperSource
        fillMode: Image.PreserveAspectCrop
        smooth: true
        cache: true
        asynchronous: false

        layer.enabled: true
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: 1.0
            blurMax: 64
            brightness: -0.10
            saturation: -0.15
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.32)
    }

    Column {
        id: clockCol
        visible: surface.isMain
        anchors.horizontalCenter: parent.horizontalCenter
        y: (surface.height - height) / 2 - (surface.restFieldH + surface.pillGap) / 2
        opacity: surface.unlocking ? 0 : 1
        Behavior on opacity {
            NumberAnimation {
                duration: 220
            }
        }
        spacing: 6 * surface.s

        ThemedText {
            anchors.horizontalCenter: parent.horizontalCenter
            text: surface.dateText
            color: Theme.colour.foregroundSubtle
            font.pixelSize: 15 * surface.s
            font.weight: Font.DemiBold
            font.letterSpacing: 3 * surface.s
            opacity: 0.85
        }

        ThemedText {
            anchors.horizontalCenter: parent.horizontalCenter
            text: DateTime.time
            color: Theme.colour.foregroundDefault
            font.pixelSize: 82 * surface.s
            font.weight: Font.Bold
            font.features: {
                "tnum": 1
            }
        }
    }

    LockPill {
        id: field
        visible: surface.isMain
        anchors.horizontalCenter: parent.horizontalCenter
        y: surface.unlocking
            ? surface.topGap
            : clockCol.y + clockCol.height + surface.pillGap
        Behavior on y {
            NumberAnimation {
                duration: Motion.morph
                easing.type: Motion.easeMorph
                easing.bezierCurve: Motion.morphCurve
            }
        }
        s: surface.s
        auth: surface.auth
        active: surface.active && surface.isMain
        collapsing: surface.unlocking
    }
}
