import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick
import "_Shared"

Control {
    id: root

    default property alias content: container.data

    property int paddingHorizontal: 12
    property int paddingVertical: 6

    leftPadding: paddingHorizontal
    rightPadding: paddingHorizontal
    topPadding: paddingVertical
    bottomPadding: paddingVertical

    background: Rectangle {
        color: Theme.colour.surfaceDefault
        radius: height / 2
    }

    contentItem: RowLayout {
        id: container
        spacing: 8
    }
}
