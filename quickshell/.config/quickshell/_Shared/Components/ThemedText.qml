import Quickshell
import QtQuick
import "../Singletons"

Text {
    id: root

    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
    color: Theme.colour.foregroundDefault
    font.weight: Font.Medium

    renderType: Text.NativeRendering
}
