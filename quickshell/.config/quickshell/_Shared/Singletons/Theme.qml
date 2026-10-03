pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property string fontFamily: "SF Pro Text"
    readonly property int defaultFontWeight: Font.Normal
    readonly property int fontSize: 13
    readonly property int fontSizeExtraSmall: 9
    readonly property int fontSizeSmall: 11
    readonly property int fontSizeLarge: 15
    readonly property int fontSizeXLarge: 18
    readonly property int fontSizeXXLarge: 24

    readonly property real shadowOpacity: 0.5
    readonly property color sheen: Qt.rgba(230 / 255, 214 / 255, 203 / 255, 0.02)

    readonly property var colour: Colours

    /**
     * Semantic aliases for the Ricelin-derived surfaces (launcher, inbox,
     * toasts). They map the upstream token names onto the gruvbox palette so
     * those components read the same here as they do upstream.
     */
    readonly property string font: fontFamily
    readonly property color cream: colour.foregroundDefault
    readonly property color bright: colour.foregroundDefault
    readonly property color subtle: colour.foregroundSubtle
    readonly property color dim: colour.foregroundSubtle
    readonly property color faint: colour.foregroundMuted
    readonly property color ghost: colour.foregroundMuted
    readonly property color iconDim: colour.foregroundMuted
    readonly property color verm: colour.verm
    readonly property color vermLit: colour.vermLit
    readonly property color vermDim: colour.accentMuted
    readonly property color flameGlow: colour.flameGlow
    readonly property color flameInk: colour.flameInk
    readonly property color tileBg: colour.surfaceOverlay
    readonly property color border: colour.border
    readonly property color hair: colour.border
    readonly property color frameBg: colour.surfaceOverlay
    readonly property color frameBorder: colour.border
    readonly property color creamMenu: Qt.alpha(cream, 0.82)
    readonly property color cardTop: colour.surfaceLight
    readonly property color cardBot: colour.surfaceDefault
    readonly property color shadow: Qt.rgba(colour.shadow.r, colour.shadow.g, colour.shadow.b, shadowOpacity)
}
