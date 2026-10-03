pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

/**
 * Owner of external-monitor brightness (ddcutil) for the mixer. `detect()`
 * enumerates DDC/CI-capable monitors; each mixer fader reads and writes its own
 * monitor's brightness over the same setvcp/getvcp wire format, which lives
 * here so every caller speaks it the same. Machines with no DDC monitors simply
 * expose an empty list and no brightness faders.
 */
Singleton {
    id: root

    /** DDC-capable monitors from `ddcutil detect`: [{ bus, label }]. */
    property var monitors: []

    /** True once a detection pass has completed (even with no monitors). */
    property bool detected: false

    function detect() {
        ddcDetect.running = true;
    }

    function setBrightness(bus, pct) {
        Quickshell.execDetached(["timeout", "3", "ddcutil", "setvcp", "10",
            String(pct), "--bus", bus, "--noverify"]);
    }

    /**
     * Parses a `ddcutil getvcp --brief` line, returning the current brightness
     * percent or -1 when no value is present.
     */
    function parseBrightness(text) {
        var m = text.match(/C\s+(\d+)\s+/);
        return m ? parseInt(m[1], 10) : -1;
    }

    Process {
        id: ddcDetect
        command: ["timeout", "4", "ddcutil", "detect", "--brief"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                var mons = [];
                var blocks = this.text.split(/\bDisplay \d+/);
                for (var i = 0; i < blocks.length; i++) {
                    var bus = /I2C bus:\s+\/dev\/i2c-(\d+)/.exec(blocks[i]);
                    var conn = /DRM connector:\s+card\d+-(\S+)/.exec(blocks[i]);
                    if (bus)
                        mons.push({ bus: bus[1], label: conn ? conn[1] : "BUS " + bus[1] });
                }
                root.monitors = mons;
                root.detected = true;
            }
        }
    }
}
