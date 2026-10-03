pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import "_Shared/Singletons"
import "_Shared/Components"

/**
 * Mixer surface. A row of vertical ink faders for the things that matter at a
 * glance — external-monitor brightness (ddcutil), output volume and microphone
 * volume — with output/input device pickers underneath, and a second page
 * listing per-app playback streams with inline volume and mute.
 *
 * Ame docks on whichever fader is focused (hover, wheel or keyboard), matching
 * the bead language used by the power surface.
 */
ThePillSurface {
    id: root

    mTop: 15
    mLeft: 17
    mRight: 17
    mBottom: 14

    /** "main" (faders) or "apps" (per-stream list). */
    property string page: "main"
    /** Which device dropdown is open: "out", "in", or "" for none. */
    property string openPicker: ""

    property int focusIndex: -1

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource

    /**
     * Output devices the user can make default: real sinks only, never the
     * per-app playback streams. Sorted by label so the list order stays stable
     * as nodes appear and vanish.
     */
    readonly property var outputSinks: {
        void Pipewire.nodes.values;
        var out = [];
        var all = Pipewire.nodes.values;
        for (var i = 0; i < all.length; i++) {
            var n = all[i];
            if (n && n.isSink && !n.isStream && n.audio)
                out.push(n);
        }
        out.sort((a, b) => root.deviceLabel(a).localeCompare(root.deviceLabel(b)));
        return out;
    }

    /**
     * Input devices the user can make default: real sources only. The sink
     * monitors that Pipewire exposes alongside real mics also match
     * isSink=false, so they are dropped by name to keep the list to actual
     * capture devices.
     */
    readonly property var inputSources: {
        void Pipewire.nodes.values;
        var out = [];
        var all = Pipewire.nodes.values;
        for (var i = 0; i < all.length; i++) {
            var n = all[i];
            if (n && !n.isSink && !n.isStream && n.audio && !/monitor/i.test(n.name || ""))
                out.push(n);
        }
        out.sort((a, b) => root.deviceLabel(a).localeCompare(root.deviceLabel(b)));
        return out;
    }

    /** Per-app playback streams (sink-side streams), sorted by label. */
    readonly property var streams: {
        void Pipewire.nodes.values;
        var out = [];
        var all = Pipewire.nodes.values;
        for (var i = 0; i < all.length; i++) {
            var n = all[i];
            if (n && n.isStream && n.isSink && n.audio)
                out.push(n);
        }
        out.sort((a, b) => root.deviceLabel(a).localeCompare(root.deviceLabel(b)));
        return out;
    }

    function deviceLabel(node) {
        if (!node)
            return "";
        return node.description || node.nickname || node.name || "";
    }

    readonly property int faderCount: faders.length
    readonly property var faders: {
        void brRep.count;
        var out = [];
        for (var i = 0; i < brRep.count; i++) {
            var f = brRep.itemAt(i);
            if (f)
                out.push(f);
        }
        out.push(volFader, micFader);
        return out;
    }

    /**
     * Tick centre of the focused fader, mapped into this mixer's root so the
     * bead glides as keyboard/hover focus moves across the row. Layout deps are
     * voided before mapToItem so the binding re-evaluates on resize (else stale).
     */
    readonly property point focusTickPoint: {
        void root.width;
        void root.height;
        void root.focusIndex;
        const i = Math.max(0, Math.min(root.faders.length - 1, root.focusIndex));
        const f = root.faders[i];
        if (!f)
            return Qt.point(0, 0);
        return f.mapToItem(root, f.tickCenter.x, f.tickCenter.y);
    }

    ameForm: (root.page === "main" && root.faderCount > 0) ? "tick" : "off"
    amePoint: root.focusTickPoint

    implicitHeight: 22 * root.s + 1 + 10 * root.s + body.height

    /**
     * Pointer-driven fader targeting. MouseArea hover is unreliable on this
     * layer-shell surface, so a non-blocking HoverHandler is the hover source;
     * its pointer x maps to a fader column while the pointer is over the row.
     */
    readonly property int hoverIndex: {
        if (root.page !== "main" || root.openPicker.length > 0 || !hoverTracker.hovered || root.width <= 0 || root.faders.length === 0)
            return -1;
        const p = hoverTracker.point.position;
        const top = 22 * root.s + 1 + 10 * root.s;
        const bot = top + faderRow.height;
        if (p.y < top || p.y > bot)
            return -1;
        return Math.max(0, Math.min(root.faders.length - 1, Math.floor(p.x / (root.width / root.faders.length))));
    }
    onHoverIndexChanged: if (hoverIndex >= 0 && !keyLatch.running)
        focusIndex = hoverIndex

    HoverHandler {
        id: hoverTracker
    }

    /**
     * Brief keyboard-nav precedence: an arrow keypress latches focus so a stray
     * pointer move doesn't yank the target away mid-navigation.
     */
    Timer {
        id: keyLatch
        interval: Motion.standard
    }

    onActiveChanged: {
        if (active) {
            focusIndex = 0;
            Display.detect();
        } else {
            focusIndex = -1;
            openPicker = "";
            page = "main";
        }
    }

    function stepFocused(deltaPct) {
        if (focusIndex < 0 || focusIndex >= root.faders.length)
            return false;
        root.faders[focusIndex].step(deltaPct);
        keyLatch.restart();
        return true;
    }

    function moveFocus(dir) {
        if (root.faders.length === 0)
            return;
        focusIndex = focusIndex < 0 ? (dir > 0 ? 0 : root.faders.length - 1)
                                    : (focusIndex + dir + root.faders.length) % root.faders.length;
        keyLatch.restart();
    }

    PwObjectTracker {
        objects: [root.sink, root.source].concat(root.outputSinks).concat(root.inputSources).concat(root.streams).filter(Boolean)
    }

    /** Shared key router hook: hjkl/arrows drive the faders on the main page. */
    function handleKey(e, pressed) {
        if (!pressed || root.page !== "main")
            return false;
        const k = e.key;
        if (k === Qt.Key_Left || k === Qt.Key_H) {
            root.moveFocus(-1);
            return true;
        }
        if (k === Qt.Key_Right || k === Qt.Key_L) {
            root.moveFocus(1);
            return true;
        }
        if (k === Qt.Key_Up || k === Qt.Key_K) {
            root.stepFocused(5);
            return true;
        }
        if (k === Qt.Key_Down || k === Qt.Key_J) {
            root.stepFocused(-5);
            return true;
        }
        return false;
    }

    /** Small icon button used for the page switch in the header. */
    component HeaderChip: Rectangle {
        id: chip
        property string glyph: ""
        property string tip: ""
        signal toggled()

        width: 24 * root.s
        height: 24 * root.s
        radius: 8 * root.s
        color: chipHover.hovered ? Theme.colour.surfaceOverlay : "transparent"
        border.width: 1
        border.color: Theme.colour.border
        Behavior on color { ColorAnimation { duration: Motion.fast } }

        GlyphIcon {
            anchors.centerIn: parent
            width: 14 * root.s
            height: 14 * root.s
            name: chip.glyph
            color: Theme.colour.foregroundSubtle
            stroke: 1.7
        }
        HoverHandler {
            id: chipHover
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: chip.toggled()
        }
    }

    Item {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 22 * root.s

        Text {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: "MIXER"
            color: Theme.colour.foregroundSubtle
            font.family: Theme.font
            font.pixelSize: 11.5 * root.s
            font.weight: Font.DemiBold
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 1.6 * root.s
        }

        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6 * root.s

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.page === "main" ? "CONTROLS" : "APPS"
                color: Theme.colour.foregroundMuted
                font.family: Theme.font
                font.pixelSize: 9.5 * root.s
                font.weight: Font.DemiBold
                font.capitalization: Font.AllUppercase
                font.letterSpacing: 1.2 * root.s
            }
            HeaderChip {
                glyph: root.page === "main" ? "music" : "mixer"
                onToggled: root.page = root.page === "main" ? "apps" : "main"
            }
        }
    }

    Rectangle {
        id: divider
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: Theme.colour.border
    }

    Item {
        id: body
        anchors.top: divider.bottom
        anchors.topMargin: 10 * root.s
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.page === "main" ? mainPage.height : appsPage.height

        Item {
            id: mainPage
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            visible: root.page === "main"
            height: faderRow.height + 12 * root.s + selectorRow.height

            Row {
                id: faderRow
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 142 * root.s
                spacing: 0

                readonly property real colW: width / Math.max(1, root.faderCount)

                Repeater {
                    id: brRep
                    model: Display.monitors

                    VFader {
                        id: brFader
                        required property var modelData
                        required property int index

                        property int pct: 75
                        property real pendingPct: -1

                        width: faderRow.colW
                        s: root.s
                        icon: "sun"
                        subLabel: brFader.modelData.label
                        focused: root.focusIndex === index
                        value: pct / 100
                        valueLabel: pct + "%"
                        onMoved: (v) => pct = Math.max(5, Math.min(100, Math.round(v * 100)))
                        onCommitted: (v) => {
                            pendingPct = Math.max(5, Math.min(100, Math.round(v * 100)));
                            brCommit.restart();
                        }

                        Timer {
                            id: brCommit
                            interval: 160
                            onTriggered: if (brFader.pendingPct >= 0) {
                                Display.setBrightness(brFader.modelData.bus, brFader.pendingPct);
                                brFader.pendingPct = -1;
                            }
                        }

                        Process {
                            id: brRead
                            command: ["timeout", "3", "ddcutil", "getvcp", "10", "--bus", brFader.modelData.bus, "--brief"]
                            running: true
                            stdout: StdioCollector {
                                onStreamFinished: {
                                    var v = Display.parseBrightness(this.text);
                                    if (v >= 0)
                                        brFader.pct = v;
                                }
                            }
                        }
                    }
                }

                VFader {
                    id: volFader
                    width: faderRow.colW
                    s: root.s
                    icon: (root.sink && root.sink.audio && root.sink.audio.muted) ? "speaker-off" : "speaker"
                    subLabel: "Output"
                    focused: root.focusIndex === root.faderCount - 2
                    value: root.sink && root.sink.audio ? root.sink.audio.volume : 0
                    valueLabel: (root.sink && root.sink.audio && root.sink.audio.muted)
                        ? "off"
                        : (Math.round((root.sink && root.sink.audio ? root.sink.audio.volume : 0) * 100) + "%")
                    onMoved: (v) => { if (root.sink && root.sink.audio) root.sink.audio.volume = v; }

                    MouseArea {
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 32 * root.s
                        height: 22 * root.s
                        cursorShape: Qt.PointingHandCursor
                        onClicked: if (root.sink && root.sink.audio)
                            root.sink.audio.muted = !root.sink.audio.muted
                    }
                }

                VFader {
                    id: micFader
                    width: faderRow.colW
                    s: root.s
                    icon: (root.source && root.source.audio && root.source.audio.muted) ? "mic-off" : "mic"
                    subLabel: "Microphone"
                    focused: root.focusIndex === root.faderCount - 1
                    value: root.source && root.source.audio ? root.source.audio.volume : 0
                    valueLabel: (root.source && root.source.audio && root.source.audio.muted)
                        ? "off"
                        : (Math.round((root.source && root.source.audio ? root.source.audio.volume : 0) * 100) + "%")
                    onMoved: (v) => { if (root.source && root.source.audio) root.source.audio.volume = v; }

                    MouseArea {
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 32 * root.s
                        height: 22 * root.s
                        cursorShape: Qt.PointingHandCursor
                        onClicked: if (root.source && root.source.audio)
                            root.source.audio.muted = !root.source.audio.muted
                    }
                }
            }

            Row {
                id: selectorRow
                anchors.top: faderRow.bottom
                anchors.topMargin: 12 * root.s
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 8 * root.s

                DeviceSelect {
                    width: (selectorRow.width - selectorRow.spacing) / 2
                    kind: "out"
                    glyph: "speaker"
                    label: root.deviceLabel(root.sink)
                    onToggled: root.openPicker = root.openPicker === "out" ? "" : "out"
                }
                DeviceSelect {
                    width: (selectorRow.width - selectorRow.spacing) / 2
                    kind: "in"
                    glyph: "mic"
                    label: root.deviceLabel(root.source)
                    onToggled: root.openPicker = root.openPicker === "in" ? "" : "in"
                }
            }

            DeviceMenu {
                kind: "out"
                model: root.outputSinks
                current: root.sink
                onPick: (node) => Pipewire.preferredDefaultAudioSink = node
            }

            DeviceMenu {
                kind: "in"
                model: root.inputSources
                current: root.source
                onPick: (node) => Pipewire.preferredDefaultAudioSource = node
            }

            MouseArea {
                id: wheelArea
                anchors.fill: faderRow
                acceptedButtons: Qt.NoButton
                property real acc: 0
                onWheel: (event) => {
                    acc += event.angleDelta.y / 120;
                    const notches = Math.trunc(acc);
                    if (notches !== 0 && root.stepFocused(notches * 5))
                        acc -= notches;
                    event.accepted = true;
                }
            }
        }

        Item {
            id: appsPage
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            visible: root.page === "apps"
            height: appsHeader.height + Math.min(Math.max(root.streams.length, 1), 5) * 42 * root.s

            Item {
                id: appsHeader
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 18 * root.s

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: "PLAYBACK"
                    color: Theme.colour.foregroundSubtle
                    font.family: Theme.font
                    font.pixelSize: 9.5 * root.s
                    font.weight: Font.DemiBold
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 1.3 * root.s
                }
                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.streams.length + (root.streams.length === 1 ? " stream" : " streams")
                    color: Theme.colour.foregroundMuted
                    font.family: Theme.font
                    font.pixelSize: 9.5 * root.s
                }
            }

            ListView {
                id: streamList
                anchors.top: appsHeader.bottom
                anchors.topMargin: 6 * root.s
                anchors.left: parent.left
                anchors.right: parent.right
                height: Math.min(Math.max(root.streams.length, 1), 5) * 42 * root.s
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                model: root.streams

                delegate: Item {
                    id: srow
                    required property var modelData

                    readonly property var node: modelData
                    readonly property var audio: srow.node ? srow.node.audio : null
                    readonly property bool muted: !!(srow.audio && srow.audio.muted)

                    width: streamList.width
                    height: 42 * root.s

                    GlyphIcon {
                        id: streamIcon
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: 16 * root.s
                        height: 16 * root.s
                        name: srow.muted ? "speaker-off" : "music"
                        color: srow.muted ? Theme.colour.foregroundMuted : Theme.colour.foregroundSubtle
                        stroke: 1.7
                    }

                    Item {
                        id: muteBtn
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        width: 22 * root.s
                        height: 22 * root.s

                        GlyphIcon {
                            anchors.centerIn: parent
                            width: 15 * root.s
                            height: 15 * root.s
                            name: srow.muted ? "speaker-off" : "speaker"
                            color: srow.muted ? Theme.colour.accent : Theme.colour.foregroundMuted
                            stroke: 1.7
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (srow.audio)
                                srow.audio.muted = !srow.audio.muted
                        }
                    }

                    Text {
                        id: pctText
                        anchors.right: muteBtn.left
                        anchors.rightMargin: 8 * root.s
                        anchors.verticalCenter: parent.verticalCenter
                        width: 30 * root.s
                        horizontalAlignment: Text.AlignRight
                        text: srow.muted ? "off" : (Math.round((srow.audio ? srow.audio.volume : 0) * 100) + "%")
                        color: srow.muted ? Theme.colour.foregroundMuted : Theme.colour.foregroundSubtle
                        font.family: Theme.font
                        font.pixelSize: 9.5 * root.s
                        font.weight: Font.DemiBold
                    }

                    HSlider {
                        id: streamSlider
                        anchors.right: pctText.left
                        anchors.rightMargin: 10 * root.s
                        anchors.verticalCenter: parent.verticalCenter
                        width: 92 * root.s
                        value: srow.audio ? srow.audio.volume : 0
                        onMoved: (v) => { if (srow.audio) srow.audio.volume = v; }
                    }

                    Text {
                        anchors.left: streamIcon.right
                        anchors.leftMargin: 10 * root.s
                        anchors.right: streamSlider.left
                        anchors.rightMargin: 10 * root.s
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.deviceLabel(srow.node)
                        elide: Text.ElideRight
                        color: Theme.colour.foregroundDefault
                        font.family: Theme.font
                        font.pixelSize: 12 * root.s
                        font.weight: Font.Medium
                    }
                }
            }

            Text {
                anchors.centerIn: streamList
                visible: root.streams.length === 0
                text: "Nothing playing"
                color: Theme.colour.foregroundMuted
                font.family: Theme.font
                font.pixelSize: 11 * root.s
            }

            WheelScroller {
                anchors.fill: streamList
                s: root.s
                flick: streamList
            }
        }
    }

    /**
     * Device dropdown: an icon + current label that opens a list of defaults.
     * Kept under the faders so it reads as the sink/source for the volume just
     * above it.
     */
    component DeviceSelect: Rectangle {
        id: sel
        property string kind: ""
        property string glyph: ""
        property string label: ""

        readonly property bool open: root.openPicker === sel.kind

        height: 24 * root.s
        radius: 8 * root.s
        color: sel.open ? Qt.alpha(Theme.colour.accent, 0.14)
            : (selHover.hovered ? Theme.colour.surfaceOverlay : "transparent")
        border.width: 1
        border.color: sel.open ? Qt.alpha(Theme.colour.accent, 0.5) : Theme.colour.border
        Behavior on color { ColorAnimation { duration: Motion.fast } }

        signal toggled()

        HoverHandler {
            id: selHover
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: sel.toggled()
        }

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 8 * root.s
            anchors.rightMargin: 8 * root.s
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6 * root.s

            GlyphIcon {
                anchors.verticalCenter: parent.verticalCenter
                width: 13 * root.s
                height: 13 * root.s
                name: sel.glyph
                color: sel.open ? Theme.colour.accent : Theme.colour.foregroundMuted
                stroke: 1.7
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 13 * root.s - 6 * root.s - 12 * root.s - 6 * root.s
                text: sel.label.length ? sel.label : "—"
                elide: Text.ElideRight
                color: Theme.colour.foregroundSubtle
                font.family: Theme.font
                font.pixelSize: 9.5 * root.s
                font.weight: Font.Medium
            }
            GlyphIcon {
                anchors.verticalCenter: parent.verticalCenter
                width: 12 * root.s
                height: 12 * root.s
                name: "chevron-down"
                color: Theme.colour.foregroundMuted
                stroke: 1.7
            }
        }
    }

    component DeviceMenu: Item {
        id: menu
        property string kind: ""
        property var model: []
        property var current
        signal pick(var node)

        readonly property bool open: root.openPicker === menu.kind

        z: 12
        visible: open
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: selectorRow.top
        anchors.bottomMargin: 6 * root.s
        width: 300 * root.s
        height: panel.height

        Rectangle {
            id: panel
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: Math.min(menu.model.length * 24 * root.s + 4 * root.s, 132 * root.s)
            clip: true
            radius: 9 * root.s
            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.colour.surfaceLight }
                GradientStop { position: 1.0; color: Theme.colour.surfaceDefault }
            }
            border.width: 1
            border.color: Theme.colour.border

            ListView {
                anchors.fill: parent
                anchors.margins: 2 * root.s
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                model: menu.model

                delegate: Rectangle {
                    id: devRow
                    required property var modelData
                    readonly property bool current: menu.current === modelData

                    width: ListView.view.width
                    height: 24 * root.s
                    radius: 7 * root.s
                    color: devRowHover.hovered ? Theme.colour.surfaceOverlay
                        : (devRow.current ? Qt.alpha(Theme.colour.accent, 0.16) : "transparent")

                    HoverHandler { id: devRowHover }

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 9 * root.s
                        anchors.right: devCheck.left
                        anchors.rightMargin: 6 * root.s
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.deviceLabel(devRow.modelData)
                        elide: Text.ElideRight
                        color: devRow.current ? Theme.colour.foregroundDefault : Theme.colour.foregroundSubtle
                        font.family: Theme.font
                        font.pixelSize: 10.5 * root.s
                        font.weight: devRow.current ? Font.Bold : Font.Medium
                    }

                    GlyphIcon {
                        id: devCheck
                        anchors.right: parent.right
                        anchors.rightMargin: 9 * root.s
                        anchors.verticalCenter: parent.verticalCenter
                        width: 13 * root.s
                        height: 13 * root.s
                        visible: devRow.current
                        name: "check"
                        color: Theme.colour.accent
                        stroke: 1.9
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            menu.pick(devRow.modelData);
                            root.openPicker = "";
                        }
                    }
                }
            }

            Text {
                anchors.centerIn: parent
                visible: menu.model.length === 0
                text: "No devices"
                color: Theme.colour.foregroundMuted
                font.family: Theme.font
                font.pixelSize: 10 * root.s
            }
        }
    }

    /** Horizontal slider for the per-app list. Value is 0..1. */
    component HSlider: Item {
        id: hsl
        property real value: 0
        signal moved(real v)
        signal committed(real v)

        implicitHeight: 16 * root.s

        Rectangle {
            id: hslTrack
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: 3 * root.s
            radius: height / 2
            color: Theme.colour.surfaceOverlay

            Rectangle {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * Math.max(0, Math.min(1, hsl.value))
                height: parent.height
                radius: parent.radius
                color: Theme.colour.vermLit
            }
        }

        Rectangle {
            id: hslKnob
            width: 8 * root.s
            height: 8 * root.s
            radius: width / 2
            anchors.verticalCenter: parent.verticalCenter
            x: Math.max(0, Math.min(parent.width - width, hsl.value * parent.width - width / 2))
            color: Theme.colour.foregroundDefault
            opacity: hslDrag.containsMouse || hslDrag.pressed ? 1 : 0.75
            Behavior on opacity { NumberAnimation { duration: Motion.fast } }
        }

        MouseArea {
            id: hslDrag
            anchors.fill: parent
            anchors.topMargin: -8 * root.s
            anchors.bottomMargin: -8 * root.s
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            function setFromX(mx) {
                hsl.moved(Math.max(0, Math.min(1, mx / hsl.width)));
            }
            onPressed: (e) => setFromX(e.x)
            onPositionChanged: (e) => { if (pressed) setFromX(e.x); }
            onReleased: hsl.committed(hsl.value)
        }
    }
}
