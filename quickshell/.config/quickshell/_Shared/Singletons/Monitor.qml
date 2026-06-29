import Quickshell
import Quickshell.Hyprland

Scope {
    id: root

    readonly property var monitors: Hyprland.monitors
    readonly property var focusedMonitor: Hyprland.focusedMonitor

    function isFocused(name) {
        return focusedMonitor && focusedMonitor.name === name;
    }
}
