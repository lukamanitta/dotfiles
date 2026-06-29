pragma Singleton

import Quickshell
import QtQuick

Scope {
    id: root
    readonly property string dateTime: {
        Qt.formatDateTime(clock.date, "ddd yyyy-MM-d hh:mm");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
