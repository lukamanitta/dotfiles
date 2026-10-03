pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import Quickshell
import "_Shared/Components"
import "_Shared/Singletons"

Item {
    id: pill

    property real s: 1
    property string screenName: ""
    property var barWindow
    property string surface: ""

    property bool hovered: false
    property bool pinned: false
    /** Last known pointer position in the overlay's coordinates. */
    property real pointerX: 0
    property real pointerY: 0

    readonly property bool held: pinned
    readonly property bool calendarOpen: surface === "calendar"
    readonly property bool launcherOpen: surface === "launcher"
    readonly property bool linkOpen: surface === "link"
    readonly property bool networkOpen: surface === "network"
    readonly property bool powerOpen: surface === "power"
    readonly property bool mixerOpen: surface === "mixer"

    readonly property bool toastActive: Notifs.popups.length > 0 && Notifs.popupMode === "pill"

    property real swipeX: 0
    property real swipeY: 0
    property real swipeFade: 1
    Behavior on swipeFade {
        NumberAnimation { duration: Motion.standard }
    }
    onToastActiveChanged: if (!toastActive) {
        swipeX = 0;
        swipeY = 0;
        swipeFade = 1;
    }

    readonly property bool surfaceOpen: surface.length > 0
    property bool hoverLatch: false
    readonly property bool expanded: surfaceOpen || hoverLatch || held || keyboardNav

    /**
     * Whether the last known pointer position sits inside the pill's hover
     * footprint. The overlay's HoverHandler cannot be trusted right after a
     * surface closes (the mask shrinks but hover state is stale until the
     * pointer moves), so closing uses this to decide whether the cursor is
     * genuinely still over the pill.
     */
    readonly property bool pointerInHover: {
        void pointerX;
        void pointerY;
        void width;
        void height;
        void hoverW;
        void hoverH;
        const cx = x + width / 2;
        return pointerX >= cx - hoverW / 2 && pointerX <= cx + hoverW / 2
            && pointerY >= y && pointerY <= y + hoverH;
    }

    /**
     * Keyboard navigation, entered from SUPER+P (IPC `pill keyboard`). While it
     * is on the pill stays expanded until Escape; hjkl/arrows move a focus over
     * the tray action buttons (and, later, player/audio buds) and Enter clicks
     * the focused one. Mouse use is unaffected (keyboardNav stays false).
     */
    property bool keyboardNav: false
    property int navIndex: -1
    /**
     * Ordered tray targets for keyboard nav, left→right. Kept as keys and
     * resolved to items/actions lazily by the functions below: an id captured
     * in a property binding would be null at construction time (the items do
     * not exist yet) and ids are not notifiable.
     */
    readonly property var navKeys: ["network", "mixer", "inbox", "dnd", "power"]

    function navItemFor(key) {
        if (key === "network")
            return netIcon;
        if (key === "mixer")
            return mixerIcon;
        if (key === "inbox")
            return inboxIcon;
        if (key === "dnd")
            return dndIcon;
        if (key === "power")
            return powerIcon;
        return null;
    }

    function navActivateKey(key) {
        if (key === "network")
            pill.requestSurface("network");
        else if (key === "mixer")
            pill.requestSurface("mixer");
        else if (key === "inbox")
            pill.requestSurface("link");
        else if (key === "dnd")
            Flags.doNotDisturb = !Flags.doNotDisturb;
        else if (key === "power")
            pill.requestSurface("power");
    }

    function navItemFocused(key) {
        return pill.keyboardNav && pill.navIndex >= 0 && pill.navIndex < pill.navKeys.length && pill.navKeys[pill.navIndex] === key;
    }

    /**
     * Central key router. The open surface gets first refusal; otherwise, when
     * tray keyboard-nav is active, arrows/hjkl and Enter drive the tray focus.
     * `pressed` distinguishes Enter-down/up so hold-to-confirm surfaces work.
     */
    function handleKey(e, pressed) {
        if (pill.ameSurface && pill.ameSurface.handleKey && pill.ameSurface.handleKey(e, pressed))
            return true;
        if (pill.keyboardNav && !pill.surfaceOpen)
            return pill.handleNavKey(e, pressed);
        return false;
    }

    function handleNavKey(e, pressed) {
        if (!pressed)
            return false;
        const k = e.key;
        if (k === Qt.Key_Left || k === Qt.Key_H || k === Qt.Key_Up || k === Qt.Key_K) {
            pill.navMove(-1);
            return true;
        }
        if (k === Qt.Key_Right || k === Qt.Key_L || k === Qt.Key_Down || k === Qt.Key_J) {
            pill.navMove(1);
            return true;
        }
        if (k === Qt.Key_Return || k === Qt.Key_Enter) {
            if (!e.isAutoRepeat)
                pill.navActivateKey(pill.navKeys[pill.navIndex]);
            return true;
        }
        return false;
    }

    function navMove(dir) {
        if (pill.navKeys.length === 0)
            return;
        const base = pill.navIndex < 0 ? (dir > 0 ? -1 : pill.navKeys.length) : pill.navIndex;
        pill.navIndex = Math.max(0, Math.min(pill.navKeys.length - 1, base + dir));
    }

    onKeyboardNavChanged: {
        if (keyboardNav) {
            closeRest.stop();
            graceTimer.stop();
            navIndex = navKeys.length - 1;
        } else {
            navIndex = -1;
            hoverLatch = false;
        }
    }

    readonly property real restPad: 8 * s
    readonly property real restW: 120 * s
    readonly property real restH: 34 * s
    readonly property real hoverPad: 20 * s
    readonly property real hoverW: hoverRow.implicitWidth + (hoverPad * 2)
    readonly property real hoverH: 58 * s

    readonly property real calendarW: 318 * s
    readonly property real calendarH: calendar.implicitHeight + 32 * s
    readonly property real launcherW: 360 * s
    readonly property real launcherH: 332 * s
    readonly property real linkW: link.desiredW
    readonly property real linkH: link.implicitHeight + 26 * s
    readonly property real networkW: 330 * s
    readonly property real networkH: network.implicitHeight + 26 * s
    readonly property real toastW: 342 * s
    readonly property real powerW: 330 * s
    readonly property real powerH: 150 * s
    readonly property real mixerW: 300 * s
    readonly property real mixerH: mixer.implicitHeight + 26 * s

    readonly property real restCornerRadius: 18 * s
    readonly property real openCornerRadius: 22 * s

    readonly property string mode: {
        if (calendarOpen)
            return "calendar";
        if (launcherOpen)
            return "launcher";
        if (linkOpen)
            return "link";
        if (networkOpen)
            return "network";
        if (powerOpen)
            return "power";
        if (mixerOpen)
            return "mixer";
        if (toastActive && !held)
            return "toast";
        return expanded ? "hover" : "rest";
    }

    signal requestSurface(string name)
    signal requestClose

    onSurfaceOpenChanged: {
        if (surfaceOpen) {
            pinned = false;
            closeRest.stop();
        } else {
            // Show the expanded hover state first, then ease back to rest.
            // Escape / mask changes leave the HoverHandler stale until the
            // pointer moves, so use the last known pointer position to decide
            // whether the cursor is really over the (hover-sized) pill. If it
            // is, stay expanded until the pointer leaves; otherwise hold the
            // hover pose briefly (closeRest) before collapsing.
            hoverLatch = true;
            if (pointerInHover) {
                closeRest.stop();
                hovered = true;
                graceTimer.stop();
            } else {
                // Arm the hold *before* clearing hovered: the guard in
                // onHoveredChanged then keeps the grace timer from collapsing us
                // mid-hold.
                closeRest.restart();
                hovered = false;
            }
        }
    }

    /**
     * Keeps the pill in its expanded hover pose for one morph after a surface
     * closes, so the transition reads instead of snapping straight to rest (the
     * grace timer alone would collapse as soon as the front-loaded morph passes
     * its closeness threshold). Bails out if the pointer has since arrived on
     * the pill.
     */
    Timer {
        id: closeRest
        interval: Motion.morph + Motion.glide
        onTriggered: {
            if (pill.hovered || pill.pointerInHover) {
                pill.hoverLatch = true;
                return;
            }
            pill.hoverLatch = false;
        }
    }

    property real morphRadius: (mode === "rest" || mode === "hover") ? restCornerRadius : openCornerRadius

    readonly property var surfaceSize: ({
            calendar: () => Qt.size(calendarW, calendarH),
            launcher: () => Qt.size(launcherW, launcherH),
            link: () => Qt.size(linkW, linkH),
            network: () => Qt.size(networkW, networkH),
            power: () => Qt.size(powerW, powerH),
            mixer: () => Qt.size(mixerW, mixerH),
            toast: () => Qt.size(toastW, (toastLoader.item ? toastLoader.item.implicitHeight : 0) + 24 * s),
            hover: () => Qt.size(hoverW, hoverH)
        })

    readonly property size targetSize: {
        const f = surfaceSize[mode];
        return f ? f() : Qt.size(Math.max(restW, restRow.implicitWidth + (restPad * 2) * s), restH);
    }
    readonly property real targetW: targetSize.width
    readonly property real targetH: targetSize.height

    width: targetW
    height: targetH

    readonly property real morphCloseness: {
        const d = Math.max(Math.abs(width - targetW), Math.abs(height - targetH));
        return 1 - Math.min(1, d / (110 * s));
    }

    // Soul bead gate (wait until hover morph is complete before allowing it to move)
    property bool hoverSoulGate: false
    readonly property bool hoverArrived: mode === "hover" && morphCloseness > 0.55
    onHoverArrivedChanged: if (hoverArrived)
        hoverSoulGate = true
    onModeChanged: if (mode !== "hover") {
        hoverSoulGate = false;
        soulTarget = "";
        soulWsIndex = -1;
    }
    onHoverSoulGateChanged: if (hoverSoulGate)
        heroFlashAnim.restart()

    property string soulTarget: ""
    property int soulWsIndex: -1

    property real heroFlash: 0

    SequentialAnimation {
        id: heroFlashAnim
        NumberAnimation {
            target: pill
            property: "heroFlash"
            to: 1
            duration: 90
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: pill
            property: "heroFlash"
            to: 0
            duration: 320
            easing.type: Easing.OutCubic
        }
    }

    Behavior on width {
        NumberAnimation {
            duration: Motion.morph
            easing.type: Motion.easeMorph
            easing.bezierCurve: Motion.morphCurve
        }
    }
    Behavior on height {
        NumberAnimation {
            duration: Motion.morph
            easing.type: Motion.easeMorph
            easing.bezierCurve: Motion.morphCurve
        }
    }
    Behavior on morphRadius {
        NumberAnimation {
            duration: Motion.morph
            easing.type: Motion.easeMorph
            easing.bezierCurve: Motion.morphCurve
        }
    }

    Rectangle {
        id: body
        anchors.fill: parent
        radius: pill.morphRadius
        border.width: 1
        border.color: "transparent"
        gradient: Gradient {
            GradientStop {
                position: 0
                color: Theme.colour.surfaceLight
            }
            GradientStop {
                position: 1
                color: Theme.colour.surfaceDefault
            }
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, Theme.shadowOpacity)
            shadowBlur: 0.7
            shadowVerticalOffset: 3 * pill.s
        }

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 1
            anchors.leftMargin: body.radius * 0.6
            anchors.rightMargin: body.radius * 0.6
            height: 1
            color: Theme.sheen
        }
    }

    // Rest anchor for bead / Ame
    readonly property point wakePoint: {
        void pill.width;
        void pill.height;
        return restHero.mapToItem(pill, restHero.width / 2, restHero.height / 2);
    }

    // Bead target while hovered
    readonly property point soulPoint: {
        void pill.width;
        void pill.height;
        void pill.keyboardNav;
        void pill.navIndex;
        const drop = 12 * pill.s;
        if (pill.keyboardNav && pill.navIndex >= 0 && pill.navIndex < pill.navKeys.length) {
            const it = pill.navItemFor(pill.navKeys[pill.navIndex]);
            if (it)
                return it.mapToItem(pill, it.width / 2, it.height / 2 + drop);
        }
        if (soulTarget === "inbox")
            return inboxIcon.mapToItem(pill, inboxIcon.width / 2, inboxIcon.height / 2 + drop);
        if (soulTarget === "power")
            return powerIcon.mapToItem(pill, powerIcon.width / 2, powerIcon.height / 2 + drop);
        if (soulTarget === "network")
            return netIcon.mapToItem(pill, netIcon.width / 2, netIcon.height / 2 + drop);
        if (soulTarget === "mixer")
            return mixerIcon.mapToItem(pill, mixerIcon.width / 2, mixerIcon.height / 2 + drop);
        if (soulTarget === "dnd")
            return dndIcon.mapToItem(pill, dndIcon.width / 2, dndIcon.height / 2 + drop);
        if (soulTarget === "ws" && soulWsIndex >= 0) {
            void ws.activeName;
            void ws.width;
            const p = ws.mapToItem(pill, ws.slotCenterX(soulWsIndex), ws.height / 2);
            return Qt.point(p.x, p.y + drop);
        }
        // return hoverHero.mapToItem(pill, hoverHero.width / 2, hoverHero.height / 2);
        return ws.mapToItem(pill, ws.activeDotPoint.x, ws.activeDotPoint.y + drop);
    }

    // Which open surface owns the bead's anchor
    readonly property var ameSurface: {
        if (calendarOpen)
            return calendar;
        if (launcherOpen)
            return launcher;
        if (linkOpen)
            return link;
        if (networkOpen)
            return network;
        if (powerOpen)
            return power;
        if (mixerOpen)
            return mixer;
        return null;
    }

    onHoveredChanged: {
        if (hovered) {
            hoverLatch = true;
            graceTimer.stop();
        } else if (!closeRest.running) {
            // While a post-close hold is in flight, closeRest owns the
            // collapse; letting the grace timer run here would snap us to rest
            // before the expanded pose has had time to read.
            graceTimer.restart();
        }
    }

    Timer {
        id: graceTimer
        interval: 300
        onTriggered: {
            if (pill.morphCloseness < 0.95) {
                graceTimer.restart();
                return;
            }
            pill.hoverLatch = false;
        }
    }

    TapHandler {
        enabled: !pill.surfaceOpen && !pill.toastActive
        gesturePolicy: TapHandler.WithinBounds
        onTapped: pill.pinned = !pill.pinned
    }

    Item {
        id: rest
        anchors.fill: parent
        opacity: (pill.expanded || pill.mode === "toast") ? 0 : Math.pow(pill.morphCloseness, 1.5)
        visible: opacity > 0.01
        Behavior on opacity {
            NumberAnimation {
                duration: pill.mode === "rest" ? Motion.fast : 260
            }
        }

        Row {
            id: restRow
            anchors.centerIn: parent
            spacing: 12 * pill.s
            Item {
                id: restHero
                anchors.verticalCenter: parent.verticalCenter
                width: heroFill.implicitWidth
                height: heroFill.implicitHeight

                AudioIndicator {
                    id: heroFill
                    anchors.verticalCenter: parent.verticalCenter
                    width: 17 * pill.s
                    height: 17 * pill.s
                    isAudioPlaying: MprisState.isPlaying
                }

                // Text {
                //     id: heroFill
                //     anchors.verticalCenter: parent.verticalCenter
                //     text: ""
                //     color: Theme.colour.foregroundDefault
                //     font.family: "Symbols Nerd Font"
                //     font.pixelSize: Theme.fontSizeXLarge * pill.s
                // }
                //
                // MultiEffect {
                //     source: heroFill
                //     anchors.fill: heroFill
                //     shadowEnabled: true
                //     shadowColor: Qt.alpha(Theme.colour.vermLit, Math.min(1, (pill.mode === "rest" || !pill.hoverSoulGate ? 0.5 : 0) + pill.heroFlash))
                //     shadowBlur: 0.3
                //     shadowVerticalOffset: 0
                //     shadowHorizontalOffset: 0
                // }
            }
            ThemedText {
                anchors.verticalCenter: parent.verticalCenter
                text: DateTime.time
                font.pixelSize: Theme.fontSizeLarge * pill.s
                font.weight: Font.Bold
                font.features: {
                    "tnum": 1
                }
            }
        }
    }

    Item {
        id: hover
        anchors.fill: parent
        opacity: pill.mode === "hover" ? Math.pow(pill.morphCloseness, 1.2) : 0
        visible: true
        Behavior on opacity {
            NumberAnimation {
                duration: pill.mode === "hover" ? Motion.fast : 40
            }
        }

        readonly property bool live: pill.mode === "hover"

        Row {
            id: hoverRow
            anchors.centerIn: parent
            spacing: 20 * pill.s

            Workspaces {
                id: ws
                anchors.verticalCenter: parent.verticalCenter
                width: implicitWidth
                screenName: pill.screenName
                s: pill.s
                gap: 8 * pill.s
                enabled: hover.live
                onHoverIndexChanged: if (hoverIndex >= 0) {
                    pill.soulTarget = "ws";
                    pill.soulWsIndex = hoverIndex;
                }
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 1
                height: 22 * pill.s
                color: Theme.colour.foregroundMuted
            }

            // Item {
            //     id: hoverHero
            //     anchors.verticalCenter: parent.verticalCenter
            //     width: hoverHeroFill.implicitWidth
            //     height: hoverHeroFill.implicitHeight
            //
            //     AudioIndicator {
            //         id: hoverHeroFill
            //         anchors.verticalCenter: parent.verticalCenter
            //         width: 17 * pill.s
            //         height: 17 * pill.s
            //         isAudioPlaying: MprisState.isPlaying
            //     }

            // Text {
            //     id: hoverHeroFill
            //     anchors.verticalCenter: parent.verticalCenter
            //     text: ""
            //     color: Theme.colour.foregroundDefault
            //     font.family: "Symbols Nerd Font"
            //     font.pixelSize: Theme.fontSizeXLarge * pill.s
            // }
            //
            // MultiEffect {
            //     source: hoverHeroFill
            //     anchors.fill: hoverHeroFill
            //     shadowEnabled: true
            //     shadowColor: Qt.alpha(Theme.colour.vermLit, Math.min(1, (pill.mode === "rest" || !pill.hoverSoulGate ? 0.5 : 0) + pill.heroFlash))
            //     shadowBlur: 0.3
            //     shadowVerticalOffset: 0
            //     shadowHorizontalOffset: 0
            // }
            // }

            // Rectangle {
            //     anchors.verticalCenter: parent.verticalCenter
            //     width: 1
            //     height: 22 * pill.s
            //     color: Theme.colour.foregroundMuted
            // }

            Item {
                anchors.verticalCenter: parent.verticalCenter
                width: hoverClock.implicitWidth
                height: hoverClock.implicitHeight

                ClockWidget {
                    id: hoverClock
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.centerIn: parent
                    width: hoverClock.implicitWidth + 22 * pill.s
                    height: hoverClock.implicitHeight + 10 * pill.s
                    enabled: hover.live
                    cursorShape: Qt.PointingHandCursor
                    onClicked: pill.requestSurface("calendar")
                }
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 1
                height: 22 * pill.s
                color: Theme.colour.foregroundMuted
            }

            Row {
                id: actionsRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12 * pill.s

                MinimisedTray {
                    id: minimised
                    anchors.verticalCenter: parent.verticalCenter
                    s: pill.s
                    screenName: pill.screenName
                    enabled: hover.live
                    visible: count > 0
                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 1
                    height: 14 * pill.s
                    color: Theme.colour.foregroundMuted
                    opacity: 0.7
                    visible: minimised.visible
                }

                Tray {
                    anchors.verticalCenter: parent.verticalCenter
                    s: pill.s
                    barWindow: pill.barWindow
                    enabled: hover.live
                }

                Item {
                    id: netIcon
                    anchors.verticalCenter: parent.verticalCenter
                    width: 17 * pill.s
                    height: 17 * pill.s

                    GlyphIcon {
                        anchors.fill: parent
                        name: "wifi"
                        stroke: 1.6 * pill.s
                        color: (netArea.containsMouse || pill.navItemFocused("network")) ? Theme.colour.foregroundDefault : Theme.colour.foregroundMuted
                    }

                    MouseArea {
                        id: netArea
                        anchors.fill: parent
                        anchors.margins: -6 * pill.s
                        hoverEnabled: true
                        enabled: hover.live
                        cursorShape: Qt.PointingHandCursor
                        onClicked: pill.requestSurface("network")
                        onContainsMouseChanged: if (containsMouse)
                            pill.soulTarget = "network"
                    }
                }

                Item {
                    id: mixerIcon
                    anchors.verticalCenter: parent.verticalCenter
                    width: 17 * pill.s
                    height: 17 * pill.s

                    GlyphIcon {
                        anchors.fill: parent
                        name: "mixer"
                        stroke: 1.6 * pill.s
                        color: (mixerArea.containsMouse || pill.navItemFocused("mixer")) ? Theme.colour.foregroundDefault : Theme.colour.foregroundMuted
                    }

                    MouseArea {
                        id: mixerArea
                        anchors.fill: parent
                        anchors.margins: -6 * pill.s
                        hoverEnabled: true
                        enabled: hover.live
                        cursorShape: Qt.PointingHandCursor
                        onClicked: pill.requestSurface("mixer")
                        onContainsMouseChanged: if (containsMouse)
                            pill.soulTarget = "mixer"
                    }
                }

                Item {
                    id: inboxIcon
                    anchors.verticalCenter: parent.verticalCenter
                    width: 17 * pill.s
                    height: 17 * pill.s

                    Text {
                        anchors.fill: parent
                        text: ""
                        font.family: "Symbols Nerd Font"
                        font.pixelSize: 17 * pill.s
                        color: (inboxArea.containsMouse || pill.navItemFocused("inbox")) ? Theme.colour.foregroundDefault : Theme.colour.foregroundMuted
                    }

                    Rectangle {
                        visible: Notifs.unread > 0
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.topMargin: -2 * pill.s
                        anchors.rightMargin: -2 * pill.s
                        width: 5 * pill.s
                        height: 5 * pill.s
                        radius: width / 2
                        color: Theme.colour.accent
                    }

                    MouseArea {
                        id: inboxArea
                        anchors.fill: parent
                        anchors.margins: -6 * pill.s
                        hoverEnabled: true
                        enabled: hover.live
                        cursorShape: Qt.PointingHandCursor
                        onClicked: pill.requestSurface("link")
                        onContainsMouseChanged: if (containsMouse)
                            pill.soulTarget = "inbox"
                    }
                }

                Item {
                    id: dndIcon
                    anchors.verticalCenter: parent.verticalCenter
                    width: 17 * pill.s
                    height: 17 * pill.s

                    GlyphIcon {
                        anchors.fill: parent
                        name: "dnd"
                        stroke: 1.6 * pill.s
                        color: Flags.doNotDisturb
                            ? ((dndArea.containsMouse || pill.navItemFocused("dnd")) ? Theme.colour.vermLit : Theme.colour.verm)
                            : ((dndArea.containsMouse || pill.navItemFocused("dnd")) ? Theme.colour.foregroundDefault : Theme.colour.foregroundMuted)
                    }

                    MouseArea {
                        id: dndArea
                        anchors.fill: parent
                        anchors.margins: -6 * pill.s
                        hoverEnabled: true
                        enabled: hover.live
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Flags.doNotDisturb = !Flags.doNotDisturb
                        onContainsMouseChanged: if (containsMouse)
                            pill.soulTarget = "dnd"
                    }
                }

                Item {
                    id: powerIcon
                    anchors.verticalCenter: parent.verticalCenter
                    width: 17 * pill.s
                    height: 17 * pill.s

                    Text {
                        anchors.fill: parent
                        text: "󰐥"
                        font.family: "Symbols Nerd Font"
                        font.pixelSize: 17 * pill.s
                        color: (powerArea.containsMouse || pill.navItemFocused("power")) ? Theme.colour.foregroundDefault : Theme.colour.foregroundMuted
                    }

                    MouseArea {
                        id: powerArea
                        anchors.fill: parent
                        anchors.margins: -6 * pill.s
                        hoverEnabled: true
                        enabled: hover.live
                        cursorShape: Qt.PointingHandCursor
                        onClicked: pill.requestSurface("power")
                        onContainsMouseChanged: if (containsMouse)
                            pill.soulTarget = "power"
                    }
                }
            }
        }
    }
    ThePillLauncher {
        id: launcher
        s: pill.s
        open: pill.launcherOpen
        morphCloseness: pill.morphCloseness
        ameArrived: ame.arrived
        onRequestClose: pill.requestClose()
    }

    ThePillLink {
        id: link
        s: pill.s
        open: pill.linkOpen
        morphCloseness: pill.morphCloseness
        ameArrived: ame.arrived
        ameArriving: ame.arriving
        ameAtTarget: ame.atTarget
        ameTick: ame.arrivalTick
        onRequestClose: pill.requestClose()
    }

    ThePillNetwork {
        id: network
        s: pill.s
        open: pill.networkOpen
        morphCloseness: pill.morphCloseness
        ameArrived: ame.arrived
        onRequestClose: pill.requestClose()
    }

    Loader {
        id: toastLoader
        active: pill.toastActive
        anchors.fill: parent
        anchors.topMargin: 12 * pill.s
        anchors.leftMargin: 16 * pill.s
        anchors.rightMargin: 16 * pill.s
        anchors.bottomMargin: 12 * pill.s
        enabled: pill.mode === "toast"
        opacity: pill.mode === "toast" ? 1 : 0
        visible: opacity > 0.01
        Behavior on opacity {
            NumberAnimation {
                duration: Motion.standard
                easing.type: Motion.easeStandard
            }
        }

        sourceComponent: Item {
            implicitHeight: toastContent.implicitHeight

            Toast {
                id: toastContent
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                s: pill.s
                live: pill.mode === "toast"
                host: pill
                notif: Notifs.popups.length > 0 ? Notifs.popups[Notifs.popups.length - 1] : null
            }

            Text {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                visible: Notifs.popups.length > 1
                text: "+" + (Notifs.popups.length - 1)
                color: Theme.colour.foregroundMuted
                font.family: Theme.fontFamily
                font.pixelSize: 9 * pill.s
                font.weight: Font.DemiBold
            }
        }
    }

    ThePillCalendar {
        id: calendar
        s: pill.s
        open: pill.calendarOpen
        morphCloseness: pill.morphCloseness
        ameArrived: ame.arrived
    }

    ThePillPower {
        id: power
        s: pill.s
        open: pill.powerOpen
        morphCloseness: pill.morphCloseness
        ameArrived: ame.arrived
        onRequestClose: pill.requestClose()
    }

    ThePillMixer {
        id: mixer
        s: pill.s
        open: pill.mixerOpen
        morphCloseness: pill.morphCloseness
        ameArrived: ame.arrived
        onRequestClose: pill.requestClose()
    }

    /**
     * Ame is declared last so the glowing bead draws over the surfaces; the
     * inbox row hover fills are opaque and were covering its seam when it sat
     * below them.
     */
    Ame {
        id: ame
        anchors.fill: parent
        s: pill.s
        heat: pill.powerOpen ? power.holdProgress : 0
        wake: pill.wakePoint
        wickDir: pill.powerOpen ? 1 : -1
        form: pill.ameSurface ? pill.ameSurface.ameForm : (pill.mode === "hover" && pill.hoverSoulGate ? "soul" : "off")
        point: pill.ameSurface ? Qt.point(pill.ameSurface.x + pill.ameSurface.amePoint.x, pill.ameSurface.y + pill.ameSurface.amePoint.y) : (pill.mode === "hover" ? pill.soulPoint : pill.wakePoint)
        concealed: pill.ameSurface ? pill.ameSurface.ameConcealed : false
    }
}
