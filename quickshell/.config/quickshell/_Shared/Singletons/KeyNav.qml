pragma Singleton

import QtQuick
import Quickshell

/**
 * Canonical direction keys for every keyboard-driven surface. The pill treats
 * arrows and hjkl as the same navigation input; keeping the alias table in one
 * place stops a new surface from supporting only one of the two.
 *
 * Text fields are the deliberate exception: launcher/clipboard/link search
 * boxes must receive h/j/k/l as typing, so they keep binding arrows directly.
 */
Singleton {
    id: root

    readonly property int none: 0
    readonly property int left: 1
    readonly property int right: 2
    readonly property int up: 3
    readonly property int down: 4

    /** Canonical direction for arrows and hjkl, or `none`. */
    function direction(e) {
        if (!e)
            return root.none;
        switch (e.key) {
        case Qt.Key_Left:
        case Qt.Key_H:
            return root.left;
        case Qt.Key_Right:
        case Qt.Key_L:
            return root.right;
        case Qt.Key_Up:
        case Qt.Key_K:
            return root.up;
        case Qt.Key_Down:
        case Qt.Key_J:
            return root.down;
        }
        return root.none;
    }

    /** -1 for left, 1 for right, 0 otherwise. */
    function horizontal(e) {
        const d = root.direction(e);
        return d === root.left ? -1 : (d === root.right ? 1 : 0);
    }

    /** -1 for up, 1 for down, 0 otherwise. */
    function vertical(e) {
        const d = root.direction(e);
        return d === root.up ? -1 : (d === root.down ? 1 : 0);
    }

    function isActivate(e) {
        return !!e && (e.key === Qt.Key_Return || e.key === Qt.Key_Enter);
    }
}
