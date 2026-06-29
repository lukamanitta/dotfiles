import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick
import "../Singletons"

Control {
    id: root

    default property alias content: container.data

    property string orientation: "horizontal" // "horizontal" or "vertical"
    property int pillCrossAxis

    property int paddingAxis: 12
    property int paddingCrossAxis: pillCrossAxis ? 0 : 6

    property int containerCrossAxis: orientation === "horizontal" ? container.implicitHeight : container.implicitWidth
    property int contentCrossAxis: containerCrossAxis + (paddingCrossAxis * 2)
    property int actualCrossAxis: pillCrossAxis ? pillCrossAxis : contentCrossAxis

    property int contentAxis: orientation === "horizontal" ? container.implicitWidth : container.implicitHeight
    property int actualAxis: contentAxis + (paddingAxis * 2)

    implicitWidth: orientation === "horizontal" ? actualAxis : actualCrossAxis
    implicitHeight: orientation === "horizontal" ? actualCrossAxis : actualAxis

    property int itemSpacing: 12

    verticalPadding: orientation === "horizontal" ? paddingCrossAxis : paddingAxis
    horizontalPadding: orientation === "horizontal" ? paddingAxis : paddingCrossAxis

    background: Rectangle {
        color: Theme.colour.surfaceDefault
        radius: orientation === "horizontal" ? height / 2 : width / 2
    }

    contentItem: RowLayout {
        id: container
        spacing: root.itemSpacing
    }
}
