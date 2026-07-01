pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property string fontFamily: "SF Pro Text"
    readonly property string defaultFontWeight: Font.Regular
    readonly property int fontSize: 13
    readonly property int fontSizeExtraSmall: 9
    readonly property int fontSizeSmall: 11
    readonly property int fontSizeLarge: 15
    readonly property int fontSizeXLarge: 18
    readonly property int fontSizeXXLarge: 24

    readonly property real shadowOpacity: 0.5
    readonly property color sheen: Qt.rgba(230 / 255, 214 / 255, 203 / 255, 0.02)

    readonly property var colour: Colours
}
