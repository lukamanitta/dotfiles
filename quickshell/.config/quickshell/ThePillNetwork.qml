pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Networking
import "_Shared/Singletons"
import "_Shared/Components"

/**
 * Network surface: overall connectivity badge, a Wi-Fi radio toggle, and one
 * row per network device showing its type, name, state and address (with the
 * connected SSID for Wi-Fi). Backed by Quickshell.Networking.
 */
ThePillSurface {
    id: root

    mTop: 15
    mLeft: 17
    mRight: 17
    mBottom: 14

    readonly property var devices: Networking.devices ? Networking.devices.values : []
    readonly property bool hasWifi: devices.some(d => d.type === DeviceType.Wifi)

    implicitHeight: mainCol.implicitHeight

    ameForm: "off"
    amePoint: Qt.point(width / 2, height / 2)

    function connLabel(c) {
        if (c === NetworkConnectivity.Full)
            return "Connected";
        if (c === NetworkConnectivity.Limited)
            return "Limited";
        if (c === NetworkConnectivity.Portal)
            return "Captive portal";
        if (c === NetworkConnectivity.None)
            return "Offline";
        return "Unknown";
    }

    function stateLabel(d) {
        if (d.type === DeviceType.Wifi && d.connected) {
            var nets = d.networks ? d.networks.values : [];
            for (var i = 0; i < nets.length; i++)
                if (nets[i].connected && nets[i].name)
                    return nets[i].name;
        }
        if (d.connected)
            return d.address && d.address.length ? d.address : "Connected";
        if (d.state === ConnectionState.Connecting)
            return "Connecting…";
        return ConnectionState.toString(d.state);
    }

    component Radio: Rectangle {
        id: sw
        property bool checked: false
        signal toggled()
        width: 36 * root.s
        height: 20 * root.s
        radius: height / 2
        color: sw.checked ? Theme.colour.accentMuted : Theme.colour.surfaceOverlay
        border.width: 1
        border.color: sw.checked ? Theme.colour.accent : Theme.colour.border
        Behavior on color { ColorAnimation { duration: Motion.fast } }

        Rectangle {
            width: 14 * root.s
            height: 14 * root.s
            radius: height / 2
            y: 3 * root.s
            x: sw.checked ? sw.width - width - 3 * root.s : 3 * root.s
            color: sw.checked ? Theme.colour.accent : Theme.colour.foregroundMuted
            Behavior on x { NumberAnimation { duration: Motion.fast; easing.type: Motion.easeStandard } }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: sw.toggled()
        }
    }

    Column {
        id: mainCol
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 4 * root.s

        Item {
            width: parent.width
            height: 24 * root.s

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: "NETWORK"
                color: Theme.colour.foregroundSubtle
                font.family: Theme.font
                font.pixelSize: 11.5 * root.s
                font.weight: Font.DemiBold
                font.capitalization: Font.AllUppercase
                font.letterSpacing: 1.6 * root.s
            }

            Row {
                x: parent.width - width
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6 * root.s

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 7 * root.s
                    height: 7 * root.s
                    radius: width / 2
                    color: Networking.connectivity === NetworkConnectivity.Full ? Theme.colour.accent : Theme.colour.critical
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.connLabel(Networking.connectivity)
                    color: Theme.colour.foregroundMuted
                    font.family: Theme.font
                    font.pixelSize: 10.5 * root.s
                    font.weight: Font.Medium
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            color: Theme.colour.border
        }

        Item {
            width: parent.width
            height: 34 * root.s
            visible: root.hasWifi

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10 * root.s

                GlyphIcon {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 18 * root.s
                    height: 18 * root.s
                    name: "wifi"
                    stroke: 1.8
                    color: Networking.wifiEnabled ? Theme.colour.accent : Theme.colour.foregroundMuted
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Wi-Fi"
                    color: Theme.colour.foregroundDefault
                    font.family: Theme.font
                    font.pixelSize: 12 * root.s
                    font.weight: Font.Medium
                }
            }

            Radio {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                checked: Networking.wifiEnabled
                onToggled: Networking.wifiEnabled = !Networking.wifiEnabled
            }
        }

        Repeater {
            model: root.devices

            delegate: Item {
                id: dev
                required property var modelData

                width: mainCol.width
                height: 40 * root.s

                Row {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10 * root.s

                    GlyphIcon {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 18 * root.s
                        height: 18 * root.s
                        name: dev.modelData.type === DeviceType.Wired ? "ethernet" : "wifi"
                        stroke: 1.8
                        color: dev.modelData.connected ? Theme.colour.foregroundDefault : Theme.colour.foregroundMuted
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 28 * root.s
                        spacing: 1 * root.s

                        Text {
                            width: parent.width
                            text: dev.modelData.name && dev.modelData.name.length ? dev.modelData.name : DeviceType.toString(dev.modelData.type)
                            color: Theme.colour.foregroundDefault
                            font.family: Theme.font
                            font.pixelSize: 12.5 * root.s
                            font.weight: Font.Medium
                            elide: Text.ElideRight
                        }
                        Text {
                            width: parent.width
                            text: root.stateLabel(dev.modelData)
                            color: dev.modelData.connected ? Theme.colour.accent : Theme.colour.foregroundMuted
                            font.family: Theme.font
                            font.pixelSize: 10.5 * root.s
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }

        Text {
            width: parent.width
            topPadding: 12 * root.s
            bottomPadding: 12 * root.s
            visible: root.devices.length === 0
            text: "No network devices"
            color: Theme.colour.foregroundMuted
            font.family: Theme.font
            font.pixelSize: 10.5 * root.s
        }
    }
}
