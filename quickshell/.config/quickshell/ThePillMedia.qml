pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Quickshell.Widgets
import "_Shared/Singletons"
import "_Shared/Components"

/**
 * Now-playing surface. Album art bleeds in on the left, faded into a blurred
 * copy behind a warm wash; the active player's title and artist scroll if they
 * overflow, and transport controls sit above a progress line. The line is
 * straight while paused and gently wavy while playing. Players that do not
 * report a length (Firefox/YouTube) simply have no line.
 *
 * Ame rides the head of the progress line and flies to a transport button when
 * one is hovered, filling it the same way the inbox fills its Open button.
 */
ThePillSurface {
    id: root

    mTop: 0
    mLeft: 0
    mRight: 0
    mBottom: 0

    implicitHeight: 150 * s

    readonly property var player: Players.active
    readonly property bool hasPlayer: player !== null
    readonly property bool playing: Players.playing
    readonly property string title: Players.has ? Players.title : "Nothing playing"
    readonly property string artist: Players.artist
    readonly property string service: Players.serviceLabel

    /**
     * Art only decodes while the surface is open, keyed on the track so a
     * browser reusing one file path still reloads on a new song.
     */
    readonly property string coverSource: {
        if (!active)
            return "";
        var u = Players.artUrl;
        if (!u)
            return "";
        return u.indexOf("file:") === 0 ? u + "#" + Players.trackKey : u;
    }
    property bool everReady: false
    onCoverSourceChanged: if (coverSource.length === 0) everReady = false

    readonly property real lengthSec: Players.lengthSec
    readonly property bool lengthKnown: Players.lengthKnown
    readonly property real positionSec: hasPlayer && player.positionSupported ? player.position : 0
    readonly property real playFrac: lengthKnown ? Math.max(0, Math.min(1, positionSec / lengthSec)) : 0
    property real dragFrac: 0
    property bool dragging: false
    readonly property real frac: dragging ? dragFrac : playFrac

    /** Source picker: only worth offering when there is a real choice. */
    property bool picking: false
    readonly property bool canPick: Players.pickable.length > 1
    onCanPickChanged: if (!canPick) picking = false

    /** Ame hover-fill hand-off over the transport buttons. */
    property Item ameHoverItem: null
    property bool ameFilled: false

    readonly property real textX: 124 * s
    readonly property real edgePad: 16 * s
    readonly property color washMid: mix(Theme.cardTop, Theme.cardBot, 0.5)

    function mix(a, b, t) {
        return Qt.rgba(a.r + (b.r - a.r) * t, a.g + (b.g - a.g) * t, a.b + (b.b - a.b) * t, 1);
    }

    function fmt(sec) {
        if (!(sec > 0))
            return "0:00";
        var t = Math.floor(sec);
        var m = Math.floor(t / 60);
        var ss = t % 60;
        return m + ":" + (ss < 10 ? "0" + ss : ss);
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

    onAmeArrivingChanged: if (ameArriving && ameHoverItem)
        ameFilled = true
    onAmeTickChanged: if (ameTick > 0 && ameHoverItem)
        ameFilled = true

    readonly property Item ameHoverTarget: ameHoverItem

    /** The progress head, or the card centre when there is no scrubber. */
    readonly property point seamPoint: {
        void root.width;
        void root.height;
        void root.frac;
        if (!lengthKnown)
            return Qt.point(root.width / 2, root.height / 2);
        return stroke.mapToItem(root, stroke.headX, stroke.headY);
    }

    ameForm: ameHoverItem !== null ? "dock" : (lengthKnown ? "seam" : "off")
    amePoint: ameHoverItem !== null
        ? ameHoverItem.mapToItem(root, ameHoverItem.width / 2, ameHoverItem.height / 2)
        : seamPoint
    ameConcealed: ameHoverItem !== null && ameFilled && ameAtTarget

    function handleKey(e, pressed) {
        if (!pressed)
            return false;
        const k = e.key;
        if (k === Qt.Key_Space) {
            if (player && player.canTogglePlaying)
                player.togglePlaying();
            return true;
        }
        if (k === Qt.Key_Left) {
            if (player && player.canGoPrevious)
                player.previous();
            return true;
        }
        if (k === Qt.Key_Right) {
            if (player && player.canGoNext)
                player.next();
            return true;
        }
        if (k === Qt.Key_Up || k === Qt.Key_Down) {
            if (!player || !lengthKnown || !player.canSeek || !player.positionSupported)
                return true;
            const delta = k === Qt.Key_Up ? 10 : -10;
            player.position = Math.max(0, Math.min(lengthSec, positionSec + delta));
            return true;
        }
        return false;
    }

    onActiveChanged: {
        if (!active) {
            picking = false;
            dragging = false;
            ameHoverItem = null;
            ameFilled = false;
        }
    }

    /** The player's position is not a notifiable property; poll while visible. */
    Timer {
        interval: 500
        running: root.active && root.playing
        repeat: true
        onTriggered: if (root.player) root.player.positionChanged()
    }

    component ArtDot: ClippingRectangle {
        id: dot
        property string url: ""
        radius: width / 2
        color: Theme.tileBg

        Image {
            anchors.fill: parent
            source: dot.url
            sourceSize: Qt.size(Math.ceil(width * 2), Math.ceil(height * 2))
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            visible: status === Image.Ready
        }
    }

    // Blurred art bleed + warm wash. The pill body is hidden underneath.
    ClippingRectangle {
        anchors.fill: parent
        radius: 22 * root.s
        color: "transparent"

        Image {
            id: bleedSrc
            anchors.fill: parent
            source: root.coverSource
            sourceSize: Qt.size(128, 128)
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            retainWhileLoading: true
            cache: String(source).indexOf("file:") !== 0
            visible: false
        }

        MultiEffect {
            anchors.fill: parent
            source: bleedSrc
            scale: 1.12
            visible: root.active && bleedSrc.status === Image.Ready
            blurEnabled: true
            blur: 0.95
            blurMax: 64
        }

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.alpha(Theme.cardTop, 0.88) }
                GradientStop { position: 1.0; color: Qt.alpha(Theme.cardBot, 0.93) }
            }
        }

        Item {
            id: coverBox
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 112 * root.s
            clip: true

            Rectangle {
                anchors.fill: parent
                color: Theme.tileBg
                visible: !root.everReady
            }

            Image {
                anchors.fill: parent
                source: root.coverSource
                sourceSize: Qt.size(Math.ceil(width * 2), Math.ceil(height * 2))
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                retainWhileLoading: true
                cache: String(source).indexOf("file:") !== 0
                onStatusChanged: if (status === Image.Ready) root.everReady = true
            }

            GlyphIcon {
                anchors.centerIn: parent
                width: 40 * root.s
                height: width
                name: "music"
                color: Theme.subtle
                visible: !root.everReady
            }
        }

        // Fade the cover into the wash.
        Rectangle {
            anchors.left: coverBox.right
            anchors.leftMargin: -32 * root.s
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 44 * root.s
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: Qt.alpha(root.washMid, 0) }
                GradientStop { position: 1.0; color: root.washMid }
            }
        }
    }

    Column {
        anchors.left: parent.left
        anchors.leftMargin: root.textX
        anchors.right: parent.right
        anchors.rightMargin: root.edgePad
        anchors.top: parent.top
        anchors.topMargin: 20 * root.s
        spacing: 3 * root.s

        Marquee {
            width: parent.width
            text: root.title
            color: Theme.cream
            pixelSize: 15 * root.s
            weight: Font.DemiBold
            active: root.active
        }
        Marquee {
            width: parent.width
            text: root.artist
            color: Theme.dim
            pixelSize: 11.5 * root.s
            active: root.active
            visible: text.length > 0
        }
    }

    Item {
        id: infoLine
        anchors.left: parent.left
        anchors.leftMargin: root.textX
        anchors.right: root.picking ? parent.right : transport.left
        anchors.rightMargin: root.picking ? root.edgePad : 10 * root.s
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 38 * root.s
        height: root.picking ? 32 * root.s : 24 * root.s

        Item {
            id: infoRow
            anchors.fill: parent
            visible: opacity > 0.01
            opacity: root.picking ? 0 : 1
            Behavior on opacity { NumberAnimation { duration: Motion.fast } }

            Text {
                id: plainSource
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                visible: !root.canPick && root.service.length > 0
                text: root.service
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: 9.5 * root.s
            }

            Rectangle {
                id: srcBubble
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                visible: root.canPick
                height: 20 * root.s
                width: bubbleRow.width + 14 * root.s
                radius: height / 2
                color: Qt.alpha(Theme.vermLit, 0.16)
                border.width: 1
                border.color: Qt.alpha(Theme.vermLit, 0.55)

                Row {
                    id: bubbleRow
                    anchors.centerIn: parent
                    spacing: 5 * root.s

                    ArtDot {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 12 * root.s
                        height: 12 * root.s
                        url: Players.artUrlFor(root.player)
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.service
                        color: Theme.cream
                        font.family: Theme.font
                        font.pixelSize: 10 * root.s
                        font.weight: Font.DemiBold
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "▾"
                        color: Theme.vermLit
                        font.pixelSize: 8 * root.s
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -5 * root.s
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.picking = true
                }
            }

            Text {
                anchors.left: root.canPick ? srcBubble.right : plainSource.right
                anchors.leftMargin: 6 * root.s
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: root.lengthKnown
                    ? root.fmt(root.dragging ? root.dragFrac * root.lengthSec : root.positionSec)
                        + " / " + root.fmt(root.lengthSec)
                    : ""
                elide: Text.ElideRight
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: 9.5 * root.s
                font.features: { "tnum": 1 }
            }
        }

        Flickable {
            id: pickFlick
            anchors.fill: parent
            clip: true
            visible: opacity > 0.01
            opacity: root.picking ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: Motion.fast } }
            contentWidth: pickRow.width
            contentHeight: height
            flickableDirection: Flickable.HorizontalFlick
            boundsBehavior: Flickable.StopAtBounds

            WheelHandler {
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                onWheel: (e) => {
                    var step = e.angleDelta.y !== 0 ? e.angleDelta.y : e.angleDelta.x;
                    var max = Math.max(0, pickFlick.contentWidth - pickFlick.width);
                    pickFlick.contentX = Math.max(0, Math.min(max, pickFlick.contentX - step));
                }
            }

            Row {
                id: pickRow
                height: pickFlick.height
                spacing: 7 * root.s

                Repeater {
                    model: root.picking ? Players.pickable : []

                    delegate: Rectangle {
                        id: bub
                        required property var modelData
                        readonly property bool isActive: modelData === Players.active

                        anchors.verticalCenter: parent.verticalCenter
                        height: 32 * root.s
                        width: bubInner.width + 18 * root.s
                        radius: 11 * root.s
                        color: isActive ? Qt.alpha(Theme.vermLit, 0.2) : Qt.alpha(Theme.cream, 0.045)
                        border.width: 1
                        border.color: isActive ? Theme.vermLit : Qt.alpha(Theme.cream, 0.12)

                        Row {
                            id: bubInner
                            anchors.centerIn: parent
                            spacing: 7 * root.s

                            ArtDot {
                                anchors.verticalCenter: parent.verticalCenter
                                width: 16 * root.s
                                height: 16 * root.s
                                url: Players.artUrlFor(bub.modelData)
                            }
                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 0

                                Text {
                                    text: Players.labelOf(bub.modelData)
                                    color: bub.isActive ? Theme.cream : Theme.dim
                                    font.family: Theme.font
                                    font.pixelSize: 11 * root.s
                                    font.weight: Font.DemiBold
                                }
                                Text {
                                    text: Players.nowPlayingFor(bub.modelData)
                                    color: bub.isActive ? Theme.subtle : Theme.faint
                                    font.family: Theme.font
                                    font.pixelSize: 8.5 * root.s
                                    elide: Text.ElideRight
                                    width: Math.min(implicitWidth, 150 * root.s)
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Players.select(bub.modelData);
                                root.picking = false;
                            }
                        }
                    }
                }
            }
        }
    }

    Row {
        id: transport
        anchors.right: parent.right
        anchors.rightMargin: root.edgePad
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 34 * root.s
        spacing: 10 * root.s
        opacity: root.picking ? 0 : 1
        enabled: !root.picking
        Behavior on opacity { NumberAnimation { duration: Motion.fast } }

        AmeFill {
            id: prevBtn
            anchors.verticalCenter: parent.verticalCenter
            s: root.s
            glyph: "prev"
            opacity: root.hasPlayer && root.player.canGoPrevious ? 1 : 0.4
            filled: root.ameHoverItem === prevBtn && root.ameFilled
            onHoveredChanged: root.setAmeHover(prevBtn, hovered)
            onClicked: if (root.player && root.player.canGoPrevious) root.player.previous()
        }

        AmeFill {
            id: playBtn
            anchors.verticalCenter: parent.verticalCenter
            s: root.s
            size: 30
            glyph: root.playing ? "pause" : "play"
            opacity: root.hasPlayer && root.player.canTogglePlaying ? 1 : 0.4
            filled: root.ameHoverItem === playBtn && root.ameFilled
            onHoveredChanged: root.setAmeHover(playBtn, hovered)
            onClicked: if (root.player && root.player.canTogglePlaying) root.player.togglePlaying()
        }

        AmeFill {
            id: nextBtn
            anchors.verticalCenter: parent.verticalCenter
            s: root.s
            glyph: "next"
            opacity: root.hasPlayer && root.player.canGoNext ? 1 : 0.4
            filled: root.ameHoverItem === nextBtn && root.ameFilled
            onHoveredChanged: root.setAmeHover(nextBtn, hovered)
            onClicked: if (root.player && root.player.canGoNext) root.player.next()
        }
    }

    /**
     * Progress line, hidden when the player reports no usable length. The wave
     * is a travelling sine while playing and a straight line while paused.
     */
    Canvas {
        id: stroke
        anchors.left: parent.left
        anchors.leftMargin: root.textX
        anchors.right: parent.right
        anchors.rightMargin: root.edgePad
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8 * root.s
        height: 18 * root.s
        visible: root.lengthKnown
        opacity: root.lengthKnown ? 1 : 0

        property real phase: 0
        readonly property real drawF: root.frac
        readonly property real inset: 3 * root.s
        readonly property real usable: Math.max(1, width - 2 * inset)
        readonly property real headX: inset + drawF * usable
        readonly property real headY: waveY(drawF)

        function waveY(u) {
            if (!root.playing)
                return height / 2;
            return height / 2 + Math.sin(u * Math.PI * 4 + phase) * 2.2 * root.s;
        }

        onDrawFChanged: requestPaint()
        onPhaseChanged: requestPaint()
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onVisibleChanged: if (visible) requestPaint()

        NumberAnimation on phase {
            running: root.active && root.playing && root.lengthKnown
            loops: Animation.Infinite
            from: 0
            to: Math.PI * 2
            duration: 2400
        }

        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            if (width <= 0 || height <= 0)
                return;

            const n = 48;
            function trace(from, to) {
                ctx.beginPath();
                const m = Math.max(2, Math.ceil(n * (to - from)));
                for (let i = 0; i <= m; i++) {
                    const u = from + ((to - from) * i) / m;
                    const x = inset + u * usable;
                    if (i === 0)
                        ctx.moveTo(x, waveY(u));
                    else
                        ctx.lineTo(x, waveY(u));
                }
            }

            ctx.lineCap = "round";
            ctx.lineJoin = "round";

            ctx.strokeStyle = Theme.border;
            ctx.lineWidth = 2.2 * root.s;
            trace(0, 1);
            ctx.stroke();

            if (drawF <= 0.002)
                return;
            ctx.strokeStyle = Theme.vermLit;
            ctx.lineWidth = 2.6 * root.s;
            trace(0, drawF);
            ctx.stroke();
        }

        MouseArea {
            anchors.fill: parent
            anchors.topMargin: -6 * root.s
            anchors.bottomMargin: -6 * root.s
            enabled: root.lengthKnown && root.hasPlayer && root.player.canSeek && root.player.positionSupported
            cursorShape: Qt.PointingHandCursor

            function fracAt(mx) {
                return Math.max(0, Math.min(1, (mx - stroke.inset) / stroke.usable));
            }

            onPressed: (e) => {
                root.dragFrac = fracAt(e.x);
                root.dragging = true;
            }
            onPositionChanged: (e) => {
                if (pressed)
                    root.dragFrac = fracAt(e.x);
            }
            onReleased: {
                if (root.player)
                    root.player.position = root.dragFrac * root.lengthSec;
                root.dragging = false;
            }
        }
    }
}
