import QtQuick
import "_Shared/Singletons"

/**
 * Rest-pill level visualiser: four rounded bars fed by the default sink's
 * PipeWire peak monitor. Idle they collapse into the same four dots the pill
 * always had; while audio plays they chase real levels with a short ease so the
 * motion stays liquid instead of strobing.
 */
Item {
    id: root

    property real s: 1
    property bool isAudioPlaying: Players.playing

    implicitWidth: bars.implicitWidth
    implicitHeight: 17 * s

    Row {
        id: bars
        anchors.centerIn: parent
        width: implicitWidth
        height: 17 * root.s
        spacing: 2 * root.s

        Repeater {
            model: AudioLevels.bars

            delegate: Rectangle {
                required property int index

                width: 4 * root.s
                radius: width / 2
                anchors.verticalCenter: parent.verticalCenter
                color: Theme.colour.accent
                height: root.isAudioPlaying
                    ? Math.max(4 * root.s, 4 * root.s + (AudioLevels.levels[index] || 0) * 11 * root.s)
                    : 4 * root.s
                Behavior on height {
                    NumberAnimation {
                        duration: 110
                        easing.type: Easing.OutQuad
                    }
                }
            }
        }
    }
}
