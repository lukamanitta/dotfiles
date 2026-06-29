import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "_Shared/Singletons"
import "_Shared/Components"

ThemedText {
    text: " " + SysMetrics.memUsageGB + "gb"

    Process {
        id: btopProcess
        running: false
        command: ["ghostty", "-e", "btop"]
    }

    MouseArea {
        anchors.fill: parent
        anchors.topMargin: -10
        anchors.bottomMargin: -10
        anchors.leftMargin: -4
        anchors.rightMargin: -4

        cursorShape: Qt.PointingHandCursor
        onClicked: {
            btopProcess.running = true;
        }
    }
}
