import Quickshell
import QtQuick
import Quickshell.Networking
import QtQuick.Layouts
import "_Shared/Components"

RowLayout {
    id: root

    property var connectedNetwork: Networking.devices.values.find(function (device) {
        return device.connected;
    })

    property string networkText: {
        if (!connectedNetwork) {
            return " No network";
        } else {
            return "󱘖 " + connectedNetwork.name;
        }
    }

    ThemedText {
        text: root.networkText
    }
}
