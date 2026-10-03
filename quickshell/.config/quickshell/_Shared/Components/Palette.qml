pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "../Singletons"

/**
 * Reusable search palette: a search field over a ranked result list. The host
 * owns the data and behaviour; it supplies `results` (an array of objects with
 * `title`, optional `subtitle`, optional `icon` path, optional `glyph` name and
 * any host-specific fields) and reacts to `accepted()` / `dismissed()`. The
 * selected item is `results[selectedIndex]`.
 *
 * Used by the app launcher today; other providers (IPC commands, flags) feed
 * the same component, so one shell can host several palettes.
 */
Item {
    id: root

    property real s: 1
    property string placeholder: "Search"
    property string emptyText: "No matches"
    property var results: []
    property int selectedIndex: 0
    property point lastPointer: Qt.point(-1, -1)
    /** Text shown in the field when it is empty (lets hosts hint at prefixes). */
    property string hint: ""

    readonly property alias query: search.text
    readonly property alias input: search.input

    readonly property point caretPoint: {
        void root.width;
        void search.input.width;
        return search.input.mapToItem(root, search.input.cursorRectangle.x + search.input.cursorRectangle.width / 2, search.input.cursorRectangle.y + search.input.cursorRectangle.height / 2);
    }

    signal accepted()
    signal dismissed()
    signal moved(int delta)

    function focusField() {
        search.input.forceActiveFocus();
    }

    function reset() {
        search.text = "";
        selectedIndex = 0;
    }

    function move(d) {
        if (results.length === 0)
            return;
        selectedIndex = Math.max(0, Math.min(results.length - 1, selectedIndex + d));
        list.positionViewAtIndex(selectedIndex, ListView.Contain);
    }

    onResultsChanged: if (selectedIndex >= results.length)
        selectedIndex = 0

    SearchField {
        id: search
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        s: root.s
        placeholder: root.query.length === 0 && root.hint.length > 0 ? root.hint : root.placeholder
        counterText: root.results.length + (root.results.length === 1 ? " item" : " items")
        onTextChanged: root.selectedIndex = 0
        onMoved: d => root.move(d)
        onAccepted: root.accepted()
        onDismissed: root.dismissed()
    }

    Rectangle {
        id: divider
        anchors.top: search.bottom
        anchors.topMargin: 8 * root.s
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: Theme.colour.border
    }

    Text {
        anchors.centerIn: list
        visible: root.results.length === 0
        text: root.emptyText
        color: Theme.colour.foregroundMuted
        font.family: Theme.fontFamily
        font.pixelSize: 11 * root.s
    }

    ListView {
        id: list
        anchors.top: divider.bottom
        anchors.topMargin: 6 * root.s
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 2 * root.s
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        model: root.results.length

        delegate: Item {
            id: row

            required property int index

            readonly property var item: root.results[index]
            readonly property bool selected: index === root.selectedIndex

            width: list.width
            height: 38 * root.s

            Rectangle {
                anchors.fill: parent
                radius: 9 * root.s
                visible: row.selected || rowArea.containsMouse
                color: row.selected ? Theme.colour.surfaceOverlay : "transparent"
                border.width: row.selected ? 1 : 0
                border.color: Theme.colour.border
            }

            MouseArea {
                id: rowArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onPositionChanged: m => {
                    var g = rowArea.mapToItem(null, m.x, m.y);
                    if (g.x !== root.lastPointer.x || g.y !== root.lastPointer.y) {
                        root.lastPointer = Qt.point(g.x, g.y);
                        root.selectedIndex = row.index;
                    }
                }
                onClicked: {
                    root.selectedIndex = row.index;
                    root.accepted();
                }
            }

            Item {
                anchors.fill: parent
                anchors.leftMargin: 11 * root.s
                anchors.rightMargin: 11 * root.s

                Item {
                    id: iconSlot
                    anchors.verticalCenter: parent.verticalCenter
                    width: 22 * root.s
                    height: 22 * root.s

                    Image {
                        anchors.fill: parent
                        sourceSize.width: Math.round(44 * root.s)
                        sourceSize.height: Math.round(44 * root.s)
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        smooth: true
                        visible: !!(row.item && row.item.icon && row.item.icon.length > 0)
                        source: row.item && row.item.icon ? Quickshell.iconPath(row.item.icon, true) : ""
                    }

                    GlyphIcon {
                        anchors.centerIn: parent
                        width: 18 * root.s
                        height: 18 * root.s
                        visible: !(row.item && row.item.icon && row.item.icon.length > 0) && !!(row.item && row.item.glyph && row.item.glyph.length > 0)
                        name: row.item && row.item.glyph ? row.item.glyph : ""
                        stroke: 1.9
                        color: Theme.colour.foregroundSubtle
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        visible: !(row.item && row.item.icon && row.item.icon.length > 0) && !(row.item && row.item.glyph && row.item.glyph.length > 0)
                        width: 7 * root.s
                        height: 7 * root.s
                        radius: 2 * root.s
                        rotation: 45
                        color: Theme.colour.accent
                    }
                }

                Text {
                    id: title
                    anchors.left: iconSlot.right
                    anchors.leftMargin: 10 * root.s
                    anchors.right: subtitle.left
                    anchors.rightMargin: 8 * root.s
                    anchors.verticalCenter: parent.verticalCenter
                    text: row.item ? row.item.title : ""
                    color: Theme.colour.foregroundDefault
                    font.family: Theme.fontFamily
                    font.pixelSize: 13 * root.s
                    font.weight: row.selected ? Font.DemiBold : Font.Normal
                    elide: Text.ElideRight
                }

                Text {
                    id: ret
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    text: "↵"
                    color: Theme.colour.accent
                    font.family: Theme.fontFamily
                    font.pixelSize: 12 * root.s
                    visible: row.selected
                    width: visible ? implicitWidth + 6 * root.s : 0
                    horizontalAlignment: Text.AlignRight
                }

                Text {
                    id: subtitle
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: ret.left
                    text: row.item && row.item.subtitle ? row.item.subtitle : ""
                    color: Theme.colour.foregroundSubtle
                    font.family: Theme.fontFamily
                    font.pixelSize: 10.5 * root.s
                    elide: Text.ElideRight
                    width: Math.min(implicitWidth, parent.width * 0.4)
                    horizontalAlignment: Text.AlignRight
                }
            }
        }
    }
}
