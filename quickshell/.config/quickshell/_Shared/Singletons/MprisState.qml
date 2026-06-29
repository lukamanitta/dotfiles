pragma Singleton
import Quickshell
import Quickshell.Services.Mpris

Scope {
    id: root

    readonly property var activePlayer: Mpris.players.values[0]
    readonly property bool isPlaying: activePlayer ? (activePlayer.playbackState === MprisPlaybackState.Playing) : false

    readonly property string artist: activePlayer && activePlayer.metadata ? (activePlayer.metadata["xesam:artist"] ? activePlayer.metadata["xesam:artist"][0] : "") : ""
    readonly property string title: activePlayer && activePlayer.metadata ? (activePlayer.metadata["xfce:title"] || activePlayer.metadata["xesam:title"] || "") : ""

    readonly property string artistAndTitle: (artist && title) ? (artist + " • " + title) : ""
}
