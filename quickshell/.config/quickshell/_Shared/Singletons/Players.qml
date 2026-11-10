pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

/**
 * The one now-playing source the pill views read: the media surface, the source
 * picker, the media bud and the OSD. Selection is by player object so a manual
 * pick survives metadata churn and falls away when that player's process dies.
 * `active` is the player you last picked by hand, else the one auto-tracked by
 * playback, which holds against a background tab that autoplays.
 *
 * Deliberately lean compared with the Ricelin original: no Netflix/Twitch
 * scraping, no global shortcuts. Everything here comes straight from MPRIS.
 */
Singleton {
    id: root

    function isProxy(p) {
        return (p && p.dbusName ? p.dbusName : "").toLowerCase().indexOf("playerctld") >= 0;
    }

    function isIdle(p) {
        if (!p || isProxy(p))
            return true;
        return !p.isPlaying && (!p.trackTitle || p.trackTitle.length === 0);
    }

    function otherPlaying(self) {
        var l = root.list;
        for (var i = 0; i < l.length; i++)
            if (l[i] !== self && l[i].isPlaying)
                return true;
        return false;
    }

    readonly property var list: {
        var all = Mpris.players.values;
        var out = [];
        for (var i = 0; i < all.length; i++)
            if (all[i] && !isProxy(all[i]))
                out.push(all[i]);
        return out;
    }

    /** Players worth offering in the source picker. */
    readonly property var pickable: {
        var l = root.list;
        var out = [];
        for (var i = 0; i < l.length; i++)
            if (!isIdle(l[i]))
                out.push(l[i]);
        return out;
    }

    property var manualActive: null
    property var preferred: null

    property bool ready: false
    Component.onCompleted: ready = true

    onListChanged: {
        if (manualActive && list.indexOf(manualActive) < 0)
            manualActive = null;
        if (preferred && list.indexOf(preferred) < 0)
            preferred = null;
    }

    /**
     * A playing player always wins, with the recently-played one preferred while
     * it plays. Only when nothing is playing do we hold the paused preferred, so
     * pausing your music doesn't hand the surface to a paused background tab, yet
     * actually starting another player switches to it.
     */
    readonly property var autoPick: {
        var l = root.list;
        if (l.length === 0)
            return null;
        if (preferred && l.indexOf(preferred) >= 0 && preferred.isPlaying)
            return preferred;
        for (var i = 0; i < l.length; i++)
            if (l[i].isPlaying && !isIdle(l[i]))
                return l[i];
        if (preferred && l.indexOf(preferred) >= 0 && !isIdle(preferred))
            return preferred;
        for (var j = 0; j < l.length; j++)
            if (!isIdle(l[j]) && l[j].trackTitle)
                return l[j];
        return l[0];
    }

    readonly property var active: (manualActive && list.indexOf(manualActive) >= 0 && !isIdle(manualActive)) ? manualActive : autoPick

    function select(p) {
        root.manualActive = (p && list.indexOf(p) >= 0) ? p : null;
    }

    Instantiator {
        model: Mpris.players

        delegate: QtObject {
            required property var modelData
            readonly property bool real: modelData && !Players.isProxy(modelData)
            readonly property bool playing: real ? modelData.isPlaying : false
            readonly property string title: real && modelData.trackTitle ? modelData.trackTitle : ""

            onPlayingChanged: {
                if (!Players.ready)
                    return;
                if (playing) {
                    if (!Players.isIdle(modelData) && !Players.otherPlaying(modelData))
                        Players.preferred = modelData;
                    Players.announce(modelData);
                } else if (modelData === Players.active) {
                    Players.announce(modelData);
                }
            }

            /**
             * Browser DRM players often land their title while isPlaying still
             * reads false and never cleanly toggle it, so announce on any real
             * title while the player is active or playing.
             */
            onTitleChanged: {
                if (Players.ready && title.length > 0 && (playing || modelData === Players.active))
                    Players.announce(modelData);
            }
        }
    }

    readonly property bool has: active !== null
    readonly property bool playing: has && active.isPlaying
    /** Falls back to the service label so a titleless DRM stream still names its source. */
    readonly property string title: has ? (active.trackTitle || labelOf(active)) : ""
    readonly property string artist: has ? joinArtists(active.trackArtists, active.trackArtist) : ""
    readonly property string album: has && active.trackAlbum ? active.trackAlbum : ""
    readonly property string artUrl: artUrlFor(active)
    readonly property string serviceLabel: has ? labelOf(active) : ""

    /** Length is only trustworthy when the player says it supports it. */
    readonly property bool lengthKnown: has && active.lengthSupported && active.length > 0 && active.length < 86400
    readonly property real lengthSec: lengthKnown ? active.length : 0
    readonly property real positionSec: has && active.positionSupported ? active.position : 0
    readonly property bool live: has && !lengthKnown

    /** Browsers reuse one art path per video, so fold player and title in. */
    function keyFor(p) {
        return p ? ((p.dbusName || "") + "|" + (p.trackTitle || "") + "|" + artUrlFor(p)) : "";
    }
    readonly property string trackKey: has ? keyFor(active) : ""

    /**
     * Fired when a player starts, pauses or changes track. The OSD listens and
     * decides whether the player is the active one worth flashing.
     */
    signal announce(var player)

    function artUrlFor(p) {
        return p && p.trackArtUrl ? p.trackArtUrl : "";
    }

    function labelOf(p) {
        if (!p)
            return "";
        var n = p.identity || p.desktopEntry || p.dbusName || "";
        return String(n).replace(/^org\.mpris\.MediaPlayer2\./, "");
    }

    function joinArtists(artists, single) {
        // MPRIS gives xesam:artist as a list, but some players expose a plain
        // string; treating that as an array would comma-separate every letter.
        if (typeof artists === "string")
            return artists.length > 0 ? artists : (single || "");
        if (artists && artists.length !== undefined) {
            var out = [];
            for (var i = 0; i < artists.length; i++)
                if (artists[i])
                    out.push(artists[i]);
            if (out.length > 0)
                return out.join(", ");
        }
        return single || "";
    }

    function nowPlayingFor(p) {
        return p && p.trackTitle ? p.trackTitle : "";
    }
}
