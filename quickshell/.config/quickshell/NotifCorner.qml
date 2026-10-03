pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "_Shared/Singletons"
import "_Shared/Components"

/**
 * Optional secondary notification presentation: a stack of popup cards in the
 * top-right of every monitor, shown only while Notifs.popupMode === "corner".
 * Cards share the pill toast's NotifCard content and morph out of / back into
 * the corner via ListView add/remove transitions. The pile lives in a ListModel
 * synced from Notifs.popups so removals animate instead of popping. Top/right
 * offset matches the pill's rest offset. The two presentations never both
 * render because they test the same mode.
 *
 * The card deliberately avoids `layer`-based effects (MultiEffect shadows):
 * the layer texture is allocated at the delegate's first (unsized) geometry and
 * clips the grown card, which read as the bottom being sliced off. A
 * RectangularShadow draws behind the card without a layer instead.
 */
PanelWindow {
    id: root

    required property var modelData

    readonly property real s: modelData ? modelData.height / 1080 : 1
    readonly property bool active: Notifs.popups.length > 0 && Notifs.popupMode === "corner"

    /**
     * Keep the surface mapped for a beat after the last popup leaves so the
     * ListView remove transition can actually run; unmapping immediately on an
     * empty model cut the exit morph off before it started.
     */
    property bool mapped: false
    onActiveChanged: {
        if (active) {
            mapped = true;
            hold.stop();
        } else {
            hold.restart();
        }
    }
    Timer {
        id: hold
        interval: 600
        onTriggered: root.mapped = false
    }

    screen: modelData
    visible: mapped
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.namespace: "notif-corner"

    /** Same gap the pill leaves from the top edge (BarTest.mVert). */
    anchors {
        top: true
        right: true
    }
    margins {
        top: Math.round(6 * s)
        right: Math.round(6 * s)
    }

    /**
     * The surface keeps a fixed size and is trimmed to the live content with a
     * mask. Resizing the layer surface itself while a card collapses produced a
     * one-frame compositor flicker under the card; a fixed surface has nothing
     * to reallocate, and outside the mask input passes through.
     */
    implicitWidth: Math.round(360 * s)
    implicitHeight: modelData ? modelData.height : 0
    mask: contentRegion

    Region {
        id: contentRegion
        width: root.width
        height: Math.max(0, Math.min(root.height, list.y + list.height))
    }

    ListModel {
        id: popModel
    }

    /**
     * Mirror Notifs.popups into the ListModel, adding newest at the top and
     * removing entries individually so the view can animate both directions.
     */
    function sync() {
        if (Notifs.popupMode !== "corner") {
            if (popModel.count > 0)
                popModel.clear();
            return;
        }
        var present = {};
        for (var i = 0; i < Notifs.popups.length; i++)
            present[Notifs.popups[i].id] = true;
        for (var j = popModel.count - 1; j >= 0; j--) {
            if (!present[popModel.get(j).notif.id])
                popModel.remove(j);
        }
        for (var k = 0; k < Notifs.popups.length; k++) {
            var p = Notifs.popups[k];
            var found = false;
            for (var m = 0; m < popModel.count; m++) {
                if (popModel.get(m).notif.id === p.id) { found = true; break; }
            }
            if (!found)
                popModel.insert(0, { notif: p });
        }
    }

    Component.onCompleted: sync()

    Connections {
        target: Notifs
        function onPopupsChanged() { root.sync(); }
        function onPopupModeChanged() { root.sync(); }
    }

    component Card: Item {
        id: card

        required property var notif

        readonly property real pad: 12 * root.s

        width: list.width
        height: content.implicitHeight + 2 * pad
        /**
         * Height animates like the pill's morph: expand/collapse grows the card
         * smoothly. The surface itself is fixed-size + masked, so nothing is
         * reallocated and the old resize flicker cannot return.
         */
        Behavior on height {
            NumberAnimation {
                duration: Motion.morph
                easing.type: Motion.easeMorph
                easing.bezierCurve: Motion.morphCurve
            }
        }
        transformOrigin: Item.TopRight
        /** Expand to read the full body; clicking the card body toggles it. */
        property bool expanded: false
        onExpandedChanged: Notifs.setHeld(card.notif.id, expanded)
        Component.onDestruction: Notifs.setHeld(card.notif.id, false)

        property double deadline: (Notifs.expireAt[card.notif.id] || (Date.now() + 6000))
        Timer {
            interval: Math.max(300, card.deadline - Date.now())
            running: card.notif.urgency !== NotificationUrgency.Critical && !card.expanded
            onTriggered: if (!card.expanded) Notifs.removePopup(card.notif)
        }

        Rectangle {
            id: bg
            anchors.fill: parent
            radius: 18 * root.s
            border.width: 1
            border.color: Theme.colour.border
            gradient: Gradient {
                GradientStop { position: 0; color: Theme.colour.surfaceLight }
                GradientStop { position: 1; color: Theme.colour.surfaceDefault }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: card.expanded = !card.expanded
        }

        NotifCard {
            id: content
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: card.pad
            s: root.s
            notif: card.notif
            expanded: card.expanded
            onActivate: {
                Notifs.activateNotif(card.notif);
                Notifs.removePopup(card.notif, true);
            }
            onDismiss: Notifs.removePopup(card.notif, true)
            onMuteToggled: Notifs.toggleMuteApp(content.app)
            onActionInvoked: function(action) {
                action.invoke();
                if (action.identifier === "default")
                    Notifs.raiseWindow(card.notif);
                Notifs.removePopup(card.notif, true);
            }
        }
    }

    ListView {
        id: list
        anchors.top: parent.top
        anchors.right: parent.right
        width: root.implicitWidth
        /**
         * contentHeight can be cached from the delegate's first (zero-width)
         * geometry and then never refresh when a card's wrapped text makes it
         * taller, clipping the card. childrenRect reflects the live bounds of
         * the laid-out delegates, so the view and window track the real height.
         */
        height: contentItem ? contentItem.childrenRect.height : 0
        clip: false
        spacing: Math.round(8 * root.s)
        interactive: false
        boundsBehavior: Flickable.StopAtBounds
        model: popModel
        delegate: Card {}

        add: Transition {
            NumberAnimation {
                property: "scale"
                from: 0.35
                to: 1
                duration: Motion.morph
                easing.type: Motion.easeMorph
                easing.bezierCurve: Motion.morphCurve
            }
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: Motion.standard
                easing.type: Motion.easeStandard
            }
        }

        remove: Transition {
            NumberAnimation {
                property: "scale"
                from: 1
                to: 0.2
                duration: Motion.standard
                easing.type: Easing.InCubic
            }
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: Motion.standard
                easing.type: Easing.InCubic
            }
        }

        displaced: Transition {
            NumberAnimation {
                property: "y"
                duration: Motion.standard
                easing.type: Motion.easeStandard
            }
        }
    }
}
