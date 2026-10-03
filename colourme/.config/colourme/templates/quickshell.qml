pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property color surfaceDefault: "#{{hex: base01 || hex: background}}"
    readonly property color surfaceLight: "#{{hex: multiply_brightness(base01, 1.2) || hex: multiply_brightness(background, 1.2)}}"
    readonly property color surfaceOverlay: "#{{hex: base02 || hex: multiply_brightness(base01, 1.3) || hex: multiply_brightness(background, 1.3)}}"
    readonly property color foregroundDefault: "#{{hex: base05 || hex: foreground}}"
    readonly property color foregroundSubtle: "#{{hex: base04 || hex: multiply_brightness(foreground, 0.7)}}"
    readonly property color foregroundMuted: "#{{hex: base03 || hex: bright.black}}"
    readonly property color border: "#{{hex: base03 || hex: base02 || hex: multiply_brightness(base01, 1.5)}}"
    readonly property color shadow: "#{{hex: base11 || hex: base00 || hex: background}}"
    readonly property color critical: "#{{hex: base08 || hex: regular.red}}"
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
