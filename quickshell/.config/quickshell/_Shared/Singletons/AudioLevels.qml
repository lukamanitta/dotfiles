pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

/**
 * Live output levels for the rest-pill visualiser, read from PipeWire's peak
 * monitor on the default sink. The monitor only runs while something is
 * playing (plus a short tail), so the shell is not woken at 60 Hz all day on a
 * silent machine. Peaks are per channel; the four bars are a symmetric pair of
 * L/R readings with a fast attack and a slow decay, which reads as a small
 * equaliser without pretending to be a frequency spectrum.
 */
Singleton {
    id: root

    readonly property int bars: 4
    readonly property var sink: Pipewire.defaultAudioSink

    /** Four normalized 0..1 bar levels. */
    property var levels: []

    readonly property bool active: Players.playing
    /** Keep the monitor alive briefly after pause so the bars can settle. */
    readonly property bool monitorOn: active || hold.running

    onActiveChanged: {
        if (active) {
            hold.stop();
            return;
        }
        hold.restart();
        levels = [];
    }

    Timer {
        id: hold
        interval: 500
        onTriggered: root.levels = []
    }

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }

    PwNodePeakMonitor {
        node: root.sink
        enabled: root.monitorOn
        onPeaksChanged: root.apply(peaks)
    }

    function apply(peaks) {
        if (!root.active)
            return;
        var l = peaks && peaks.length > 0 ? peaks[0] : 0;
        var r = peaks && peaks.length > 1 ? peaks[1] : l;
        l = Math.sqrt(Math.max(0, Math.min(1, l)));
        r = Math.sqrt(Math.max(0, Math.min(1, r)));
        var mid = (l + r) * 0.45;
        var targets = [l, mid, mid, r];
        var cur = root.levels;
        var out = [];
        for (var i = 0; i < root.bars; i++) {
            var c = cur[i] || 0;
            var t = targets[i] || 0;
            out.push(t > c ? t : c * 0.82 + t * 0.18);
        }
        root.levels = out;
    }
}
