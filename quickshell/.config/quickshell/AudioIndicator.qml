import QtQuick
import "_Shared/Singletons"

Row {
    id: root
    spacing: 2
    // property real implicitHeight: 20

    // Change this variable to true/false based on audio status
    property bool isAudioPlaying: MprisState.isPlaying

    // Repeater generates 4 vertical bars
    Repeater {
        model: 4
        delegate: Rectangle {
            width: 3
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.colour.accent
            radius: 1
            property bool isAudioPlaying: root.isAudioPlaying

            // Default flat state height
            height: 3

            onIsAudioPlayingChanged: {
                if (!root.isAudioPlaying) {
                    height = 3
                }
            }

            // Continuous animation loops while audio is playing
            SequentialAnimation on height {
                running: isAudioPlaying
                loops: Animation.Infinite

                NumberAnimation {
                    to: Math.random() * 16 + 4 // Random peak height
                    duration: 500 + (index * 30) // Staggered speeds
                }
                NumberAnimation {
                    to: 3 // Resets down to flat limit
                    duration: 500 + (index * 30)
                }
            }

            Behavior on height {
                NumberAnimation {
                    duration: 150
                }
            }
        }
    }
}
