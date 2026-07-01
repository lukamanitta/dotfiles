import QtQuick
import QtQuick.Layouts
import "_Shared/Components"
import "_Shared/Singletons"


// ThemedText {
//     text: DateTime.dateTime
//     font.weight: Font.Bold
// }

ColumnLayout {
    spacing: -2

    ThemedText {
        Layout.alignment: Qt.AlignHCenter
        Layout.leftMargin: 8
        Layout.rightMargin: 8

        text: DateTime.time
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
    }

    ThemedText {
        Layout.alignment: Qt.AlignHCenter
        text: DateTime.day + " " + DateTime.date
        font.pixelSize: Theme.fontSizeExtraSmall
        color: Theme.colour.foregroundMuted
        font.weight: Font.Normal
    }
}
