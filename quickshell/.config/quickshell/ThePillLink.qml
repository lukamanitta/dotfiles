pragma ComponentBehavior: Bound

import QtQuick
import "_Shared/Singletons"
import "_Shared/Components"

/**
 * Inbox surface: the notification center. Grouped per app with critical
 * entries pinned above the fold, an inline clear-all, and a silence empty
 * state; opening marks all notifications seen after a short beat so unread
 * embers register first. Docks Ame as a seam at the focused row.
 */
ThePillSurface {
    id: root

    mTop: 13
    mLeft: 16
    mRight: 16
    mBottom: 13

    readonly property real desiredW: 330 * s

    /**
     * Row-soul focus registry. Each hoverable row reports itself here; the bead
     * docks as a glowing seam at the left edge of the focused row and hides
     * when nothing is focused.
     */
    property Item focusRowItem: null
    /** The action button currently hovered, if any (the pill's Ame flies to it). */
    property Item ameHoverItem: null
    /** Latched once the Ame starts closing on the hovered action; drives the fill. */
    property bool ameFilled: false

    /** Per-notification expanded state for reading full message bodies. */
    property var expandedRows: ({})

    /**
     * Keyboard navigation over the visible inbox rows. `navRows` is the flat,
     * top-to-bottom list (critical entries, each group header, then its entries
     * when expanded); each row registers itself under a stable key so the Ame
     * can dock at the focused one. Enter toggles a group / expands an entry,
     * and opens an already-expanded entry.
     */
    property int navIndex: 0
    property var rowItems: ({})
    readonly property var navRows: {
        var rows = [];
        var gs = Notifs.groups || [];
        for (var i = 0; i < gs.length; i++) {
            var g = gs[i];
            if (g.criticals) {
                for (var c = 0; c < g.criticals.length; c++)
                    rows.push({ kind: "entry", key: "e" + g.criticals[c].n.id, entry: g.criticals[c], app: g.app });
            }
            rows.push({ kind: "group", key: "g" + g.app, app: g.app });
            if (Notifs.expandedApps[g.app] && g.entries) {
                for (var e = 0; e < g.entries.length; e++)
                    rows.push({ kind: "entry", key: "e" + g.entries[e].n.id, entry: g.entries[e], app: g.app });
            }
        }
        return rows;
    }

    function registerRow(key, item) {
        var m = Object.assign({}, rowItems);
        m[key] = item;
        rowItems = m;
    }

    function unregisterRow(key) {
        var m = Object.assign({}, rowItems);
        delete m[key];
        rowItems = m;
    }

    function applyNavFocus() {
        if (!active || navRows.length === 0) {
            focusRowItem = null;
            return;
        }
        navIndex = Math.max(0, Math.min(navRows.length - 1, navIndex));
        focusRowItem = rowItems[navRows[navIndex].key] || null;
    }

    function handleKey(e, pressed) {
        if (!pressed)
            return false;
        const k = e.key;
        if (k === Qt.Key_Up || k === Qt.Key_K) {
            root.moveNav(-1);
            return true;
        }
        if (k === Qt.Key_Down || k === Qt.Key_J) {
            root.moveNav(1);
            return true;
        }
        if (k === Qt.Key_Return || k === Qt.Key_Enter) {
            if (!e.isAutoRepeat)
                root.activateNav();
            return true;
        }
        return false;
    }

    function moveNav(d) {
        if (navRows.length === 0)
            return;
        navIndex = Math.max(0, Math.min(navRows.length - 1, navIndex + d));
        applyNavFocus();
        scrollToFocus();
    }

    function scrollToFocus() {
        const it = focusRowItem;
        if (!it)
            return;
        const y = it.mapToItem(notifCol, 0, 0).y;
        if (y < notifFlick.contentY)
            notifFlick.contentY = y;
        else if (y + it.height > notifFlick.contentY + notifFlick.height)
            notifFlick.contentY = y + it.height - notifFlick.height;
    }

    function activateNav() {
        const r = navRows[navIndex];
        if (!r)
            return;
        if (r.kind === "group") {
            Notifs.toggleExpanded(r.app);
        } else if (r.kind === "entry") {
            if (expandedRows[r.entry.n.id]) {
                Notifs.activateEntry(r.entry);
                root.requestClose();
            } else {
                root.toggleRow(r.entry.n.id);
            }
        }
    }

    function reportRowHover(item, hovered) {
        if (hovered)
            focusRowItem = item;
    }

    function setAmeHover(item, hovered) {
        if (hovered) {
            ameHoverItem = item;
            ameFilled = false;
        } else if (ameHoverItem === item) {
            ameHoverItem = null;
            ameFilled = false;
        }
    }

    /** Fill as soon as the bead is closing on the hovered action. */
    onAmeArrivingChanged: if (ameArriving && ameHoverItem)
        ameFilled = true
    /** Fallback: also fill once the bead has landed on the action. */
    onAmeTickChanged: if (ameTick > 0 && ameHoverItem)
        ameFilled = true

    function toggleRow(id) {
        var e = Object.assign({}, expandedRows);
        if (e[id])
            delete e[id];
        else
            e[id] = true;
        expandedRows = e;
    }

    readonly property bool rowFocused: focusRowItem !== null && active
    readonly property bool ameFocused: ameHoverItem !== null && active

    readonly property point rowPoint: {
        void root.width;
        void root.height;
        void mainCol.implicitHeight;
        void root.focusRowItem;
        if (!focusRowItem)
            return Qt.point(4 * s, root.height / 2);
        return focusRowItem.mapToItem(root, 4 * s, focusRowItem.height / 2);
    }

    readonly property point ameDockPoint: {
        void root.width;
        void root.height;
        void root.ameHoverItem;
        if (!ameHoverItem)
            return rowPoint;
        return ameHoverItem.mapToItem(root, ameHoverItem.width / 2, ameHoverItem.height / 2);
    }

    /**
     * Single-bead hand-off: the pill's Ame flies to the hovered action button
     * and the button fills as it closes. Only once the bead has physically come
     * to rest on it do we conceal the bead (keeping its position), so the flight
     * stays visible — and on unhover it flies back *from* the button.
     */
    ameForm: ameFocused ? "dock" : (rowFocused ? "rowseam" : "off")
    amePoint: ameFocused ? ameDockPoint : rowPoint
    ameConcealed: ameHoverItem !== null && ameFilled && ameAtTarget

    implicitHeight: mainCol.implicitHeight

    onActiveChanged: {
        if (active) {
            seenTimer.restart();
            navIndex = 0;
            Qt.callLater(applyNavFocus);
        } else {
            seenTimer.stop();
            focusRowItem = null;
            ameHoverItem = null;
            ameFilled = false;
            navIndex = 0;
        }
    }

    onNavRowsChanged: if (active)
        Qt.callLater(applyNavFocus)

    Timer {
        id: seenTimer
        interval: 600
        repeat: false
        onTriggered: Notifs.markAllSeen()
    }

    /** Ember mark: the unread marker shared by the header badge and titles. */
    component Ember: Item {
        id: ember
        property real size: 4 * root.s

        width: size * 2.2
        height: size * 2.2

        Rectangle {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            radius: width / 2
            color: Theme.flameGlow
            opacity: 0.22
        }

        Rectangle {
            anchors.centerIn: parent
            width: ember.size
            height: ember.size
            radius: width / 2
            color: Theme.flameGlow
        }
    }

    /**
     * Single inbox entry: icon tile or diamond, body text, ×N coalesce badge,
     * age label that cross-fades into a dismiss glyph on hover. Critical
     * entries gain a vermilion left hairline and cream emphasis.
     */
    component NotifRow: Rectangle {
        id: nrow

        required property var entry
        property bool critical: false
        readonly property var n: entry.n
        readonly property bool expanded: root.expandedRows[nrow.n.id] === true
        readonly property var acts: (nrow.n.actions || []).filter(function(a) { return a.text.length > 0; })
        readonly property string app: (nrow.n.appName && nrow.n.appName.length) ? nrow.n.appName : "System"
        readonly property bool muted: Notifs.isMuted(nrow.app)
        readonly property string navKey: "e" + nrow.n.id
        readonly property bool keyFocused: root.navRows.length > 0 && root.navIndex >= 0 && root.navIndex < root.navRows.length && root.navRows[root.navIndex].key === nrow.navKey

        Component.onCompleted: root.registerRow(nrow.navKey, nrow)
        Component.onDestruction: root.unregisterRow(nrow.navKey)

        width: parent ? parent.width : 0
        height: content.implicitHeight + 16 * root.s
        radius: 8 * root.s
        color: (nrowHover.hovered || nrow.expanded || nrow.keyFocused) ? Theme.frameBg : "transparent"
        border.width: nrow.keyFocused ? 1 : 0
        border.color: Theme.vermLit

        HoverHandler {
            id: nrowHover
            onHoveredChanged: root.reportRowHover(nrow, hovered)
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.toggleRow(nrow.n.id)
        }

        Rectangle {
            visible: nrow.critical
            anchors.left: parent.left
            anchors.leftMargin: 1 * root.s
            anchors.top: parent.top
            anchors.topMargin: 8 * root.s
            width: 2 * root.s
            height: nrow.height - 16 * root.s
            radius: 999
            color: Theme.verm
        }

        Column {
            id: content
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 8 * root.s
            anchors.rightMargin: 8 * root.s
            anchors.topMargin: 8 * root.s
            spacing: 6 * root.s

            Item {
                id: headRow
                width: parent.width
                height: 22 * root.s

                NotifIcon {
                    id: nrowTile
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    s: root.s
                    size: 18 * root.s
                    notif: nrow.n
                }

                Text {
                    anchors.left: nrowTile.right
                    anchors.leftMargin: 8 * root.s
                    anchors.right: nrowRight.left
                    anchors.rightMargin: 8 * root.s
                    anchors.verticalCenter: parent.verticalCenter
                    text: nrow.expanded
                        ? nrow.n.summary
                        : (nrow.n.body.length > 0 ? nrow.n.body : nrow.n.summary)
                    color: nrow.critical ? Theme.cream : Theme.subtle
                    font.family: Theme.font
                    font.pixelSize: 12 * root.s
                    font.weight: nrow.critical ? Font.DemiBold : Font.Medium
                    elide: Text.ElideRight
                    maximumLineCount: 1
                    textFormat: Text.PlainText
                }

                Row {
                    id: nrowRight
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 6 * root.s

                    Text {
                        visible: nrow.entry.count > 1
                        anchors.verticalCenter: parent.verticalCenter
                        text: "×" + nrow.entry.count
                        color: nrow.critical ? Theme.vermLit : Theme.vermDim
                        font.family: Theme.font
                        font.pixelSize: 10.5 * root.s
                        font.weight: Font.Bold
                    }

                    Item {
                        anchors.verticalCenter: parent.verticalCenter
                        width: Math.max(nrowAge.implicitWidth, nrowX.implicitWidth)
                        height: Math.max(nrowAge.implicitHeight, nrowX.implicitHeight)

                        Text {
                            id: nrowAge
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            opacity: nrowHover.hovered || nrow.expanded ? 0 : 1
                            text: Notifs.ageLabel(nrow.n)
                            color: Theme.faint
                            font.family: Theme.font
                            font.pixelSize: 10.5 * root.s
                            Behavior on opacity { NumberAnimation { duration: Motion.fast } }
                        }

                        GlyphIcon {
                            id: nrowX
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: 12 * root.s
                            height: 12 * root.s
                            opacity: nrowHover.hovered || nrow.expanded ? 1 : 0
                            name: "close"
                            color: nrowXArea.containsMouse ? Theme.cream : Theme.dim
                            stroke: 1.9
                            Behavior on opacity { NumberAnimation { duration: Motion.fast } }

                            MouseArea {
                                id: nrowXArea
                                anchors.fill: parent
                                anchors.margins: -6 * root.s
                                enabled: nrowHover.hovered || nrow.expanded
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Notifs.dismissEntry(nrow.entry)
                            }
                        }
                    }
                }
            }

            Column {
                id: expandCol
                visible: nrow.expanded
                width: parent.width
                spacing: 6 * root.s

                Text {
                    width: parent.width
                    visible: nrow.n.body.length > 0
                    text: nrow.n.body
                    color: Theme.subtle
                    font.family: Theme.font
                    font.pixelSize: 12 * root.s
                    wrapMode: Text.Wrap
                    textFormat: Text.PlainText
                }

                Row {
                    visible: nrow.acts.length > 0
                    spacing: 6 * root.s

                    Repeater {
                        model: nrow.acts

                        Rectangle {
                            id: actPill
                            required property var modelData
                            required property int index

                            height: 22 * root.s
                            width: actText.implicitWidth + 18 * root.s
                            radius: 999
                            color: Theme.tileBg
                            border.width: 1
                            border.color: Theme.border

                            Text {
                                id: actText
                                anchors.centerIn: parent
                                text: actPill.modelData.text
                                color: actPill.index === 0 ? Theme.vermLit : Theme.dim
                                font.family: Theme.font
                                font.pixelSize: 11 * root.s
                                font.weight: Font.DemiBold
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    actPill.modelData.invoke();
                                    if (actPill.modelData.identifier === "default")
                                        Notifs.raiseWindow(nrow.n);
                                    Notifs.dismissEntry(nrow.entry);
                                }
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: openBtn.implicitHeight

                    AmeFill {
                        id: openBtn
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        s: root.s
                        text: "Open"
                        filled: root.ameHoverItem === openBtn && root.ameFilled
                        onHoveredChanged: root.setAmeHover(openBtn, hovered)
                        onClicked: {
                            Notifs.activateEntry(nrow.entry);
                            root.requestClose();
                        }
                    }

                    AmeFill {
                        id: muteBtn
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        s: root.s
                        text: nrow.muted ? "Unmute" : "Mute 30m"
                        filled: nrow.muted || (root.ameHoverItem === muteBtn && root.ameFilled)
                        onHoveredChanged: root.setAmeHover(muteBtn, hovered)
                        onClicked: Notifs.toggleMuteApp(nrow.app)
                    }
                }
            }
        }
    }

    Column {
        id: mainCol
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 4 * root.s

        Item {
            width: parent.width
            height: 26 * root.s

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8 * root.s

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "INBOX"
                    color: Theme.subtle
                    font.family: Theme.font
                    font.pixelSize: 11.5 * root.s
                    font.weight: Font.DemiBold
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 1.6 * root.s
                }
            }

            Row {
                x: parent.width - width
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10 * root.s

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 6 * root.s
                    visible: Notifs.unread > 0

                    Ember {
                        id: headerEmber
                        anchors.verticalCenter: parent.verticalCenter
                        size: 6 * root.s

                        SequentialAnimation on opacity {
                            running: headerEmber.visible
                            loops: Animation.Infinite
                            NumberAnimation { from: 0.55; to: 1; duration: 1200; easing.type: Easing.InOutSine }
                            NumberAnimation { from: 1; to: 0.55; duration: 1200; easing.type: Easing.InOutSine }
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: Notifs.unread + " NEW"
                        color: Theme.dim
                        font.family: Theme.font
                        font.pixelSize: 11 * root.s
                        font.weight: Font.Bold
                        font.letterSpacing: 1.4 * root.s
                    }
                }

                Item {
                    width: clearRow.implicitWidth
                    height: clearRow.implicitHeight
                    anchors.verticalCenter: parent.verticalCenter
                    visible: Notifs.count > 0

                    Row {
                        id: clearRow
                        spacing: 4 * root.s

                        GlyphIcon {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 12 * root.s
                            height: 12 * root.s
                            name: "trash"
                            color: clearArea.containsMouse ? Theme.vermLit : Theme.vermDim
                            stroke: 1.8
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "CLEAR"
                            color: clearArea.containsMouse ? Theme.vermLit : Theme.vermDim
                            font.family: Theme.font
                        font.pixelSize: 10.5 * root.s
                        font.weight: Font.Bold
                        font.letterSpacing: 1.4 * root.s
                        }
                    }

                    MouseArea {
                        id: clearArea
                        anchors.fill: clearRow
                        anchors.margins: -5 * root.s
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Notifs.clearAll()
                    }
                }
            }
        }
        Rectangle {
            width: parent.width
            height: 1
            color: Theme.hair
        }

        Item {
            visible: Notifs.count > 0
            width: parent.width
            height: notifFlick.height

            Flickable {
                id: notifFlick
                width: parent.width
                height: Math.min(notifCol.implicitHeight, 320 * root.s)
                contentHeight: notifCol.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                onContentHeightChanged: returnToBounds()

                Column {
                    id: notifCol
                    width: notifFlick.width
                    spacing: 6 * root.s

                    Repeater {
                        model: Notifs.groups

                        Column {
                            id: group
                            required property var modelData
                            readonly property bool expanded: Notifs.expandedApps[modelData.app] === true
                            width: notifCol.width
                            spacing: 2 * root.s

                            Repeater {
                                model: group.modelData.criticals

                                NotifRow {
                                    required property var modelData
                                    entry: modelData
                                    critical: true
                                }
                            }

                            Rectangle {
                                id: groupHead
                                readonly property string navKey: "g" + group.modelData.app
                                readonly property bool keyFocused: root.navRows.length > 0 && root.navIndex >= 0 && root.navIndex < root.navRows.length && root.navRows[root.navIndex].key === groupHead.navKey

                                Component.onCompleted: root.registerRow(groupHead.navKey, groupHead)
                                Component.onDestruction: root.unregisterRow(groupHead.navKey)

                                width: parent.width
                                height: 36 * root.s
                                radius: 8 * root.s
                                color: (headHover.hovered || groupHead.keyFocused) ? Theme.frameBg : "transparent"
                                border.width: groupHead.keyFocused ? 1 : 0
                                border.color: Theme.vermLit

                                HoverHandler {
                                    id: headHover
                                    onHoveredChanged: root.reportRowHover(groupHead, hovered)
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Notifs.toggleExpanded(group.modelData.app)
                                }

                                NotifIcon {
                                    id: headTile
                                    anchors.left: parent.left
                                    anchors.leftMargin: 6 * root.s
                                    anchors.verticalCenter: parent.verticalCenter
                                    s: root.s
                                    size: 22 * root.s
                                    notif: group.modelData.newest
                                }

                                Text {
                                    id: headName
                                    anchors.left: headTile.right
                                    anchors.leftMargin: 8 * root.s
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: Math.min(implicitWidth, 110 * root.s)
                                    text: group.modelData.app
                                    color: Theme.subtle
                                    font.family: Theme.font
                                    font.pixelSize: 10.5 * root.s
                                    font.weight: Font.Bold
                                    font.capitalization: Font.AllUppercase
                                    font.letterSpacing: 1.2 * root.s
                                    elide: Text.ElideRight
                                    textFormat: Text.PlainText
                                }

                                Text {
                                    id: headCount
                                    anchors.left: headName.right
                                    anchors.leftMargin: 5 * root.s
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "· " + group.modelData.count
                                    color: Theme.faint
                                    font.family: Theme.font
                                    font.pixelSize: 10.5 * root.s
                                }

                                Text {
                                    anchors.left: headCount.right
                                    anchors.leftMargin: 8 * root.s
                                    anchors.right: headX.left
                                    anchors.rightMargin: 8 * root.s
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: group.modelData.preview.body.length > 0
                                        ? group.modelData.preview.body
                                        : group.modelData.preview.summary
                                    color: Theme.dim
                                    font.family: Theme.font
                                    font.pixelSize: 11.5 * root.s
                                    elide: Text.ElideRight
                                    maximumLineCount: 1
                                    textFormat: Text.PlainText
                                }

                                GlyphIcon {
                                    id: headChev
                                    anchors.right: parent.right
                                    anchors.rightMargin: 8 * root.s
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 12 * root.s
                                    height: 12 * root.s
                                    name: group.expanded ? "chevron-down" : "chevron-right"
                                    color: Theme.faint
                                    stroke: 2
                                }

                                GlyphIcon {
                                    id: headX
                                    anchors.right: headChev.left
                                    anchors.rightMargin: 7 * root.s
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 12 * root.s
                                    height: 12 * root.s
                                    opacity: headHover.hovered ? 1 : 0
                                    name: "close"
                                    color: headXArea.containsMouse ? Theme.cream : Theme.dim
                                    stroke: 1.9
                                    Behavior on opacity { NumberAnimation { duration: Motion.fast } }

                                    MouseArea {
                                        id: headXArea
                                        anchors.fill: parent
                                        anchors.margins: -6 * root.s
                                        enabled: headHover.hovered
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: Notifs.dismissApp(group.modelData.app)
                                    }
                                }
                            }

                            Column {
                                visible: group.expanded
                                width: parent.width
                                spacing: 2 * root.s

                                Repeater {
                                    model: group.expanded ? group.modelData.entries : []

                                    NotifRow {
                                        required property var modelData
                                        entry: modelData
                                    }
                                }
                            }
                        }
                    }
                }
            }

            WheelScroller {
                anchors.fill: parent
                s: root.s
                flick: notifFlick
            }
        }

        Column {
            visible: Notifs.count === 0
            width: parent.width
            topPadding: 14 * root.s
            bottomPadding: 14 * root.s
            spacing: 4 * root.s

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "No notifications to display"
                color: Theme.faint
                font.family: Theme.font
                font.pixelSize: 10.5 * root.s
                font.weight: Font.Bold
                font.letterSpacing: 0.8 * root.s
            }
        }
    }
}
