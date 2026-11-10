pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Quickshell.Widgets
import "_Shared/Singletons"
import "_Shared/Components"

/**
 * Now-playing surface. Album art bleeds in on the left, faded into a blurred
 * copy behind a warm wash; the active player's title and artist scroll if they
 * overflow, and transport controls sit above a progress line. The elapsed part
 * of the line is a fine travelling wave in the accent colour, the future part a
 * flat muted rail, and the seam between them carries the Ame playhead; paused,
 * the whole line goes flat. Players that do not report a length
 * (Firefox/YouTube) simply have no line.
 *
 * Ame rides the seam of the progress line and flies to a transport button when
 * one is hovered, filling it the same way the inbox fills its Open button.
 *
 * Keyboard: h/l (or arrows) scrub ±5 s, Shift+h/l skip tracks, j/k move focus
 * between the progress bar and the player chip, and Enter opens the chip's
 * picker (or toggles playback while the bar is focused).
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
    onCanPickChanged: {
        if (!canPick) {
            picking = false;
            if (keyFocus === "source")
                keyFocus = "bar";
        }
    }

    /** Keyboard focus: the progress bar, or the player-select chip above it. */
    property string keyFocus: "bar"
    /** Index into Players.pickable while the source picker is open. */
    property int pickIndex: 0

    /** Ame hover-fill hand-off over the transport buttons. */
    property Item ameHoverItem: null
    property bool ameFilled: false

    /** Square, matching the card height, so album art is not cropped to a sliver. */
    readonly property real coverW: 150 * s
    readonly property real textX: coverW + 6 * s
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

    function seekBy(delta) {
        if (!player || !lengthKnown || !player.canSeek || !player.positionSupported)
            return;
        player.position = Math.max(0, Math.min(lengthSec, positionSec + delta));
    }

    function openPicker() {
        if (!canPick)
            return;
        const list = Players.pickable;
        const i = list.indexOf(Players.active);
        pickIndex = i >= 0 ? i : 0;
        picking = true;
        keyFocus = "source";
        ensurePickVisible();
    }

    function closePicker() {
        picking = false;
        keyFocus = canPick ? "source" : "bar";
    }

    function movePick(delta) {
        const n = Players.pickable.length;
        if (n === 0)
            return;
        pickIndex = Math.max(0, Math.min(n - 1, pickIndex + delta));
        ensurePickVisible();
    }

    function choosePick() {
        const list = Players.pickable;
        if (pickIndex >= 0 && pickIndex < list.length)
            Players.select(list[pickIndex]);
        closePicker();
    }

    /** Keep the keyboard-selected player visible in the horizontal picker. */
    function ensurePickVisible() {
        if (!picking)
            return;
        const n = Players.pickable.length;
        if (n === 0) {
            picking = false;
            return;
        }
        if (pickIndex >= n)
            pickIndex = n - 1;
        const it = pickRepeater.itemAt(pickIndex);
        if (!it || pickFlick.width <= 0) {
            Qt.callLater(root.ensurePickVisible);
            return;
        }
        const maxX = Math.max(0, pickFlick.contentWidth - pickFlick.width);
        const left = it.x;
        const right = it.x + it.width;
        if (left < pickFlick.contentX)
            pickFlick.contentX = Math.max(0, left);
        else if (right > pickFlick.contentX + pickFlick.width)
            pickFlick.contentX = Math.min(maxX, right - pickFlick.width);
    }

    /** Let an open picker swallow Escape before the pill closes the surface. */
    function handleEscape() {
        if (!picking)
            return false;
        closePicker();
        return true;
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

    ameForm: ameHoverItem !== null ? "dock" : (lengthKnown ? "rowseam" : "off")
    amePoint: ameHoverItem !== null
        ? ameHoverItem.mapToItem(root, ameHoverItem.width / 2, ameHoverItem.height / 2)
        : seamPoint
    ameConcealed: ameHoverItem !== null && ameFilled && ameAtTarget

    function handleKey(e, pressed) {
        if (!pressed)
            return false;
        const k = e.key;
        const dir = KeyNav.direction(e);

        // The picker takes over horizontal keys and Enter while it is open.
        if (picking) {
            if (dir === KeyNav.left)
                movePick(-1);
            else if (dir === KeyNav.right)
                movePick(1);
            else if (KeyNav.isActivate(e)) {
                if (!e.isAutoRepeat)
                    choosePick();
            }
            return true;
        }

        if (k === Qt.Key_Space) {
            if (player && player.canTogglePlaying)
                player.togglePlaying();
            return true;
        }

        // h/l (and arrows) scrub; Shift makes them previous/next track.
        if (dir === KeyNav.left || dir === KeyNav.right) {
            const forward = dir === KeyNav.right;
            if (e.modifiers & Qt.ShiftModifier) {
                if (forward) {
                    if (player && player.canGoNext)
                        player.next();
                } else if (player && player.canGoPrevious) {
                    player.previous();
                }
            } else {
                seekBy(forward ? 5 : -5);
            }
            return true;
        }

        // j/k move keyboard focus between the bar and the player-select chip.
        if (dir === KeyNav.up || dir === KeyNav.down) {
            if (canPick)
                keyFocus = dir === KeyNav.up ? "source" : "bar";
            return true;
        }

        if (KeyNav.isActivate(e)) {
            if (!e.isAutoRepeat) {
                if (keyFocus === "source" && canPick)
                    openPicker();
                else if (player && player.canTogglePlaying)
                    player.togglePlaying();
            }
            return true;
        }
        return false;
    }

    onActiveChanged: {
        if (!active) {
            picking = false;
            keyFocus = "bar";
            pickIndex = 0;
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
            width: root.coverW
            clip: true

            Rectangle {
                anchors.fill: parent
                color: Theme.tileBg
                visible: !root.everReady
            }

            Image {
                id: coverImage
                anchors.fill: parent
                source: root.coverSource
                sourceSize: Qt.size(Math.ceil(width * 2), Math.ceil(height * 2))
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                retainWhileLoading: true
                cache: String(source).indexOf("file:") !== 0
                onStatusChanged: if (status === Image.Ready) root.everReady = true

                /**
                 * Layer the *displayed* image (PreserveAspectCrop already
                 * applied) so the shader fades its alpha without stretching the
                 * raw texture. Sampling an Image directly changed the aspect.
                 */
                layer.enabled: true
                layer.effect: ShaderEffect {
                    property real fadeStart: 0.55
                    fragmentShader: "shaders/coverfade.frag.qsb"
                }
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
                color: root.keyFocus === "source" ? Qt.alpha(Theme.vermLit, 0.24)
                    : Qt.alpha(Theme.vermLit, 0.16)
                border.width: root.keyFocus === "source" ? 1.6 : 1
                border.color: root.keyFocus === "source" ? Theme.cream : Qt.alpha(Theme.vermLit, 0.55)

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
                    onClicked: root.openPicker()
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

            onWidthChanged: if (root.picking) Qt.callLater(root.ensurePickVisible)
            onContentWidthChanged: if (root.picking) Qt.callLater(root.ensurePickVisible)

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
                    id: pickRepeater
                    model: root.picking ? Players.pickable : []

                    delegate: Rectangle {
                        id: bub
                        required property var modelData
                        required property int index
                        readonly property bool isActive: modelData === Players.active
                        readonly property bool isKeyFocus: root.picking && index === root.pickIndex

                        anchors.verticalCenter: parent.verticalCenter
                        height: 32 * root.s
                        width: bubInner.width + 18 * root.s
                        radius: 11 * root.s
                        scale: isKeyFocus ? 1.045 : 1
                        color: isKeyFocus ? Qt.alpha(Theme.cream, 0.14)
                            : (isActive ? Qt.alpha(Theme.vermLit, 0.2) : Qt.alpha(Theme.cream, 0.045))
                        border.width: isKeyFocus ? 2 * root.s : 1
                        border.color: isKeyFocus ? Theme.cream
                            : (isActive ? Theme.vermLit : Qt.alpha(Theme.cream, 0.12))
                        Behavior on scale { NumberAnimation { duration: Motion.fast } }

                        /** Caret marking the keyboard cursor inside the picker. */
                        Rectangle {
                            anchors.left: parent.left
                            anchors.leftMargin: 3 * root.s
                            anchors.verticalCenter: parent.verticalCenter
                            width: 2.5 * root.s
                            height: 12 * root.s
                            radius: width / 2
                            color: Theme.cream
                            visible: bub.isKeyFocus
                        }

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
                                root.pickIndex = index;
                                root.choosePick();
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
     * Progress line, hidden when the player reports no usable length. While
     * playing the elapsed run is a short-period travelling wave tinted with the
     * accent; the unplayed run is a flat muted rail. Both flatten on pause. The
     * Ame playhead is a vertical seam at the join.
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
        readonly property real centreY: height / 2
        /** The seam sits on the straight rail, not on the wave's local crest. */
        readonly property real headY: centreY
        readonly property real waveAmp: 2.8 * root.s

        /**
         * Wave height at `u` (0..1 across the whole track). The envelope fades
         * the wave into the centreline at both ends of the elapsed run, so it
         * grows out of the left edge and meets the flat future rail cleanly.
         */
        function waveY(u) {
            if (!root.playing || drawF <= 0)
                return centreY;
            const env = Math.min(1, u / 0.06) * Math.min(1, Math.max(0, drawF - u) / 0.06);
            return centreY + Math.sin(u * Math.PI * 16 + phase) * waveAmp * env;
        }

        function traceWave(ctx, from, to) {
            ctx.beginPath();
            const m = Math.max(2, Math.ceil(48 * (to - from)));
            for (let i = 0; i <= m; i++) {
                const u = from + ((to - from) * i) / m;
                const x = inset + u * usable;
                if (i === 0)
                    ctx.moveTo(x, waveY(u));
                else
                    ctx.lineTo(x, waveY(u));
            }
        }

        function traceFlat(ctx, from, to) {
            ctx.beginPath();
            const x1 = inset + from * usable;
            const x2 = inset + to * usable;
            ctx.moveTo(x1, centreY);
            ctx.lineTo(x2, centreY);
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

            ctx.lineCap = "round";
            ctx.lineJoin = "round";

            // Unplayed rail first: straight and muted, from the seam to the end.
            if (drawF < 0.998) {
                ctx.strokeStyle = Theme.border;
                ctx.lineWidth = 2.2 * root.s;
                traceFlat(ctx, drawF, 1);
                ctx.stroke();
            }

            if (drawF <= 0.002)
                return;
            ctx.strokeStyle = Theme.vermLit;
            ctx.lineWidth = 2.6 * root.s;
            traceWave(ctx, 0, drawF);
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
