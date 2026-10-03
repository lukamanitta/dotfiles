pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "lock"

/**
 * Standalone lock daemon. Runs an idle WlSessionLock that is flipped on either
 * by the `lock` IPC call or by a poke at $XDG_RUNTIME_DIR/lock-trigger (the
 * fast path used by lock.sh). Kept as its own quickshell process so a pill
 * restart can never drop the lock; unlock only happens after PAM succeeds.
 *
 * The entry sits at the config root (NOT lock/shell.qml) so the shared
 * _Shared singletons/components stay inside the config folder and remain
 * importable. Run with: qs -p ~/.config/quickshell/LockShell.qml
 */
ShellRoot {
    id: root

    readonly property string currentUser: Quickshell.env("USER") || Quickshell.env("LOGNAME") || ""

    property bool locked: false
    /** True between a successful auth and the actual release: drives the
     *  field's morph up into the resting pill. */
    property bool unlocking: false

    /**
     * Backdrop source: the current wallpaper itself, read from waypaper's state
     * so the lock shows the desktop's image rather than a grab of whatever
     * windows happen to be open. `~` is expanded by hand; QML's Image won't.
     */
    property string wallpaperPath: ""
    readonly property string wallpaperSource: wallpaperPath.length > 0 ? "file://" + wallpaperPath : ""

    function readWallpaper() {
        var t = wallpaperFile.text();
        var m = t.match(/^\s*wallpaper\s*=\s*(.+?)\s*$/m);
        var p = m ? m[1].trim() : "";
        if (p.charAt(0) === "~")
            p = (Quickshell.env("HOME") || "") + p.slice(1);
        root.wallpaperPath = p;
    }

    FileView {
        id: wallpaperFile
        path: (Quickshell.env("XDG_CONFIG_HOME") || (Quickshell.env("HOME") + "/.config")) + "/waypaper/wallpaper.ini"
        blockLoading: true
        watchChanges: true
        printErrors: false
        onLoaded: root.readWallpaper()
        onFileChanged: {
            reload();
            Qt.callLater(root.readWallpaper);
        }
    }

    /** Ignore startup file events; only arm once the daemon has settled. */
    property bool triggerArmed: false
    Timer {
        interval: 60
        running: true
        onTriggered: root.triggerArmed = true
    }

    Timer {
        id: fire
        interval: 30
        onTriggered: if (root.triggerArmed)
            root.locked = true
    }

    FileView {
        path: (Quickshell.env("XDG_RUNTIME_DIR") || "/tmp") + "/lock-trigger"
        watchChanges: true
        printErrors: false
        onLoadFailed: setText("0")
        onFileChanged: fire.restart()
    }

    Auth {
        id: pamAuth
        user: root.currentUser
        onSucceeded: {
            root.unlocking = true;
            release.restart();
        }
    }

    /** Let the field finish its morph to the top before the lock releases. */
    Timer {
        id: release
        interval: 520
        onTriggered: {
            root.locked = false;
            root.unlocking = false;
        }
    }

    onLockedChanged: if (locked)
        unlocking = false;

    WlSessionLock {
        id: sessionLock
        locked: root.locked

        WlSessionLockSurface {
            id: lockSurface
            color: "#101218"

            LockSurface {
                anchors.fill: parent
                s: lockSurface.screen ? lockSurface.screen.height / 1080 : 1
                screenName: lockSurface.screen ? lockSurface.screen.name : ""
                wallpaperSource: root.wallpaperSource
                auth: pamAuth
                active: root.locked
                unlocking: root.unlocking
            }
        }
    }

    IpcHandler {
        target: "lock"
        function lock(): void {
            root.locked = true;
        }
        function unlock(): void {
            root.locked = false;
        }
        function toggle(): void {
            root.locked = !root.locked;
        }
    }
}
