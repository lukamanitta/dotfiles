import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import "_Shared/Singletons"
import "_Shared/Components"

/**
 * Transient pill OSD for volume and track changes. It is not a surface: the
 * pill morphs into these dimensions for a beat, shows the level or the new
 * track, and returns to whatever it was doing.
 *
 * Volume is observed passively from the default sink, so any source (media
 * keys, the mixer, an app) produces the same feedback without routing input
 * through the shell. Track flashes fire only for the active player. Every pill
 * carries one, but only the focused monitor's may flash.
 */
Item {
    id: root

    property real s: 1
    property string screenName: ""
    property bool suppressed: false
    property bool expanded: false
    property string kind: "volume"
    property bool flashing: false
    property bool armed: false

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink && sink.audio ? sink.audio.muted : false
    readonly property real volume: sink && sink.audio ? Math.max(0, Math.min(1, sink.audio.volume)) : 0

    readonly property bool onFocusedMonitor: !Hyprland.focusedMonitor || Hyprland.focusedMonitor.name === screenName

    readonly property real desiredW: kind === "track" ? 344 * s : 248 * s
    readonly property real desiredH: kind === "track" ? 68 * s : 44 * s

    function flash(which) {
        if (!armed || suppressed || !onFocusedMonitor)
            return false;
        kind = which;
        flashing = true;
        hideTimer.interval = 1200;
        hideTimer.restart();
        return true;
    }

    onSuppressedChanged: {
        if (suppressed) {
            hideTimer.stop();
            flashing = false;
        }
    }

    Timer {
        interval: 1500
        running: true
        onTriggered: root.armed = true
    }

    Timer {
        id: hideTimer
        interval: 1200
        onTriggered: root.flashing = false
    }

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }

    Connections {
        target: root.sink && root.sink.audio ? root.sink.audio : null
        function onVolumesChanged() { root.flash("volume"); }
        function onMutedChanged() { root.flash("volume"); }
    }

    Connections {
        target: Players
        function onAnnounce(player) {
            if (player === Players.active)
                root.flash("track");
        }
    }

    Item {
        id: volRow
        anchors.fill: parent
        opacity: root.kind === "volume" ? 1 : 0
        visible: opacity > 0.01
        Behavior on opacity { NumberAnimation { duration: 150 } }

        GlyphIcon {
            id: volGlyph
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 17 * root.s
            height: 17 * root.s
            name: root.muted ? "speaker-off" : "speaker"
            color: root.muted ? Theme.dim : Theme.iconDim
            stroke: 1.7
        }

        Text {
            id: volPct
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 32 * root.s
            horizontalAlignment: Text.AlignRight
            text: Math.round(root.volume * 100) + "%"
            color: root.muted ? Theme.dim : Theme.cream
            font.family: Theme.font
            font.pixelSize: 11 * root.s
            font.weight: Font.DemiBold
            font.features: { "tnum": 1 }
        }

        Rectangle {
            anchors.left: volGlyph.right
            anchors.leftMargin: 12 * root.s
            anchors.right: volPct.left
            anchors.rightMargin: 12 * root.s
            anchors.verticalCenter: parent.verticalCenter
            height: 4 * root.s
            radius: 2 * root.s
            color: Theme.colour.surfaceOverlay

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * root.volume
                radius: parent.radius
                color: root.muted ? Theme.vermDim : Theme.vermLit
                Behavior on width { NumberAnimation { duration: Motion.fast } }
                Behavior on color { ColorAnimation { duration: Motion.fast } }
            }
        }
    }

    Item {
        id: trackRow
        anchors.fill: parent
        opacity: root.kind === "track" ? 1 : 0
        visible: opacity > 0.01
        Behavior on opacity { NumberAnimation { duration: 150 } }

        ClippingRectangle {
            id: coverBox
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 44 * root.s
            height: 44 * root.s
            radius: 9 * root.s
            color: Theme.tileBg

            Image {
                id: cover
                anchors.fill: parent
                source: Players.artUrl
                sourceSize: Qt.size(Math.ceil(width * 2), Math.ceil(height * 2))
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: String(source).indexOf("file:") !== 0
                opacity: status === Image.Ready ? 1 : 0
            }

            GlyphIcon {
                anchors.centerIn: parent
                width: parent.width * 0.42
                height: width
                name: "music"
                color: Theme.subtle
                visible: cover.status !== Image.Ready
            }
        }

        GlyphIcon {
            id: trackCtrl
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 18 * root.s
            height: 18 * root.s
            name: Players.playing ? "pause" : "play"
            color: Players.playing ? Theme.vermLit : Theme.iconDim
        }

        Column {
            anchors.left: coverBox.right
            anchors.leftMargin: 12 * root.s
            anchors.right: trackCtrl.left
            anchors.rightMargin: 12 * root.s
            anchors.verticalCenter: parent.verticalCenter
            spacing: 3 * root.s

            Text {
                width: parent.width
                text: Players.has ? Players.title : "Nothing playing"
                color: Theme.cream
                font.family: Theme.font
                font.pixelSize: 14 * root.s
                font.weight: Font.DemiBold
                maximumLineCount: 1
                elide: Text.ElideRight
            }

            Text {
                width: parent.width
                text: Players.artist
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: 11 * root.s
                maximumLineCount: 1
                elide: Text.ElideRight
                visible: text.length > 0
            }
        }
    }
}
