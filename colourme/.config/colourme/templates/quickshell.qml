pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property color surfaceDefault: "#{{hex: base00 || hex: background}}"
    readonly property color foregroundDefault: "#{{hex: base05 || hex: foreground}}"
    readonly property color foregroundMuted: "#{{hex: base03 || hex: bright.black}}"
    readonly property color accent: "#{{hex: accent}}"
    readonly property color accentMuted: "#{{hex: multiply_brightness(accent, 0.5)}}"
}
