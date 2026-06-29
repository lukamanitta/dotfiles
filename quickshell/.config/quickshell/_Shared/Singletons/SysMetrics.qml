pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property int memUsagePc: 0
    property real memUsageGB: 0.0

    property real cpuUsagePc: 0.0

    Process {
        id: memUsageProcess
        command: ["bash", "-c", "free -b | grep Mem"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                if (!data) return;
                var parts = data.trim().split(/\s+/);
                var total = parseInt(parts[1]) || 1;
                var used = parseInt(parts[2]) || 0;
                root.memUsagePc = Math.round((used / total) * 100);
                root.memUsageGB = (used / (1024 * 1024 * 1024)).toFixed(1);
            }
        }
    }

    Process {
        id: cpuUsageProcess
        command: ["bash", "-c", "top -bn1 | grep 'Cpu(s)'"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                if (!data) return;
                var parts = data.trim().split(/\s+/);
                var idle = parseFloat(parts[7]) || 0;
                root.cpuUsagePc = (100 - idle).toFixed(1);
            }
        }
    }

    Timer {
        interval: 8000
        running: true
        repeat: true
        onTriggered: {
            memUsageProcess.running = true;
            cpuUsageProcess.running = true;
        }
    }
}
