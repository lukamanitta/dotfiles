pragma Singleton

import Quickshell
import QtQuick

Scope {
    id: root
    readonly property string dateTime: {
        Qt.formatDateTime(clock.date, "ddd yyyy-MM-d hh:mm");
    }

    readonly property string time: {
        Qt.formatDateTime(clock.date, "hh:mm");
    }

    readonly property string day: {
        Qt.formatDateTime(clock.date, "ddd");
    }

    readonly property string date: {
        Qt.formatDateTime(clock.date, "d MMM");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
