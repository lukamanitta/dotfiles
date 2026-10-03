pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Shared session flags persisted to a JSON file and watched for changes.
// Allows other Quickshell daemons to share state.
Singleton {
    id: root

    property alias doNotDisturb: json.doNotDisturb
    /** Notification popup presentation: "pill" (morph toast) or "corner". */
    property alias notifMode: json.notifMode

    FileView {
        id: file
        path: Quickshell.env("HOME") + "/.local/state/LiquoRice/flags.json"
        watchChanges: true
        printErrors: false

        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        onLoadFailed: function(error) {
            if (error === FileViewError.FileNotFound)
                writeAdapter();
        }

        JsonAdapter {
            id: json
            property bool doNotDisturb: false
            property string notifMode: "pill"
        }
    }
}
