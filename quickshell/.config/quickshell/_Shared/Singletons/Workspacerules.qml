pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

/**
 * Persistent workspace→monitor map from Hyprland's workspace rules
 * (`hyprctl workspacerules -j`). This is the single source for the split that
 * monitors.lua declares, so the pill's dots show every assigned workspace on a
 * monitor even before it has been visited, instead of hardcoding monitor names.
 *
 * Empty when a setup has no rules (the usual single-monitor case); the
 * workspaces row then falls back to the live workspaces on that monitor. Re-read
 * on config reload, since editing monitors.lua rewrites the rules.
 */
Singleton {
    id: root

    /** Monitor name → sorted workspace numbers. */
    property var byMonitor: ({})

    function refresh() {
        proc.running = true;
    }

    Process {
        id: proc
        command: ["hyprctl", "workspacerules", "-j"]

        stdout: StdioCollector {
            onStreamFinished: {
                var map = {};
                var rules;
                try {
                    rules = JSON.parse(this.text);
                } catch (e) {
                    return;
                }
                if (!Array.isArray(rules))
                    return;

                for (var i = 0; i < rules.length; i++) {
                    var rule = rules[i];
                    if (!rule || !rule.monitor || rule.enabled === false)
                        continue;
                    var ws = parseInt(rule.workspaceString, 10);
                    if (isNaN(ws))
                        continue;
                    if (!map[rule.monitor])
                        map[rule.monitor] = [];
                    if (map[rule.monitor].indexOf(ws) < 0)
                        map[rule.monitor].push(ws);
                }

                for (var mon in map)
                    map[mon].sort(function (a, b) { return a - b; });
                root.byMonitor = map;
            }
        }
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "configreloaded")
                root.refresh();
        }
    }

    Component.onCompleted: refresh()
}
