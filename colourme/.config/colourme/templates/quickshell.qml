pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property color surfaceDefault: "#{{hex: base01 || hex: background}}"
    readonly property color surfaceLight: "#{{hex: multiply_brightness(base01, 1.2) || hex: multiply_brightness(background, 1.2)}}"
    readonly property color foregroundDefault: "#{{hex: base05 || hex: foreground}}"
    readonly property color foregroundMuted: "#{{hex: base03 || hex: bright.black}}"
    readonly property color accent: "#{{hex: accent}}"
    readonly property color accentMuted: "#{{hex: multiply_brightness(accent, 0.5)}}"

    readonly property color verm: "#{{hex: hsv(h(accent), 78.0, 75.0)}}"
    readonly property color vermLit: "#{{hex: hsv(h(accent), 74.0, 88.0)}}"
    readonly property color flameCore: "#{{hex: hsv(h(accent), 24.0, 100.0)}}"
    readonly property color flameGlow: "#{{hex: hsv(h(accent), 61.0, 100.0)}}"
    readonly property string flameInk: "#{{hex: hsv(h(accent), 62.0, 94.0)}}"
    readonly property string flameEmber: "#{{hex: hsv(h(accent), 86.0, 49.0)}}"
    readonly property string flameBurn: "#{{hex: hsv(h(accent), 86.0, 54.0)}}"
    readonly property string flameTip: "#{{hex: hsv(h(accent), 46.0, 100.0)}}"
}
