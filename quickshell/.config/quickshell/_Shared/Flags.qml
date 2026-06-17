pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Shared session flags persisted to a JSON file and watched for changes.
// Allows other Quickshell daemons to share state.
Singleton {
    id: root

    property alias doNotDisturb: json.doNotDisturb

    FileView {
        id: file
        path: Quickshell.env("HOME") + "/.local/state/LiquoRice/flags.json"
        blockLoading: true
        watchChanges: true
        printErrors: false

        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: json
            property bool doNotDisturb: false
        }
    }

    Component.onCompleted: if (!file.loaded)
        file.writeAdapter()
}
