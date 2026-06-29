pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property string fontFamily: "Roboto Mono"
    readonly property int fontSize: 12
    readonly property var colour: Colours

    // readonly property color verm: "#c0442b"
    // readonly property color vermLit: "#e0563b"
    // readonly property color flameCore: "#ffd9c2"
    // readonly property color flameGlow: "#ff9a64"
    // readonly property string flameInk: "#f0795a"
    // readonly property string flameEmber: "#7e2812"
    // readonly property string flameBurn: "#8a2c14"
    // readonly property string flameTip: "#ffb38a"

    readonly property color verm: "#BF2A54"
    readonly property color vermLit: "#E03A69"
    readonly property color flameCore: "#FFC2D3"
    readonly property color flameGlow: "#FF6390"
    readonly property string flameInk: "#F05B85"
    readonly property string flameEmber: "#7D1130"
    readonly property string flameBurn: "#8A1335"
    readonly property string flameTip: "#FF8AAB"
}
