import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import "_Shared/Singletons"
import "_Shared/Components"

ThemedText {
    id: root

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property PwNodeAudio pwNode: Pipewire.defaultAudioSink.audio

    property string icon: {
        if (!pwNode || pwNode.muted) {
            return "󰖁";
        } else if (pwNode.volume < 0.1) {
            return "";
        } else if (pwNode.volume < 0.5) {
            return "󰖀";
        } else {
            return "󰕾";
        }
    }

    property string volumeText: pwNode ? Math.round(pwNode.volume * 100) + "%" : "N/A"

    text: icon + " " + volumeText

    Process {
        id: wiremixProcess
        running: false
        command: ["ghostty", "-e", "wiremix", "--tab", "output"]
    }

    MouseArea {
        anchors.fill: parent
        anchors.topMargin: -10
        anchors.bottomMargin: -10
        anchors.leftMargin: -4
        anchors.rightMargin: -4

        cursorShape: Qt.PointingHandCursor

        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                wiremixProcess.running = true;
            } else if (mouse.button === Qt.RightButton) {
                pwNode.muted = !pwNode.muted;
            }
        }

        onWheel: (wheel) => {
            if (pwNode) {
                const dir = wheel.angleDelta.y > 0 ? 1 : -1;
                const step = 0.05;
                pwNode.volume = Math.min(Math.max(pwNode.volume + dir * step, 0), 1);
                wheel.accepted = true;
            }
        }
    }
}
