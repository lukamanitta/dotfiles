# Quickshell planning

Ideas and their status. **Done** items are implemented; the rest are backlog.

## Done

- **Command palette** — `_Shared/Components/Palette.qml` is a reusable
  search + result-list component; `ThePillLauncher` hosts five providers
  switched by a prefix: apps (default), `>` commands, `:` flags, `@` open
  windows and `=` calculations.
- **Ame on notification cards** — the shared `NotifCard` has an Ame bead beside
  the icon that flies to and fills the **Open** button on hover.
- **Network surface** — `ThePillNetwork.qml` (connectivity badge, Wi-Fi toggle,
  per-device rows) wired as a pill surface with a hover glyph and `network` IPC.
- **Mixer surface** — `ThePillMixer.qml`: a row of vertical ink faders (external
  DDC-monitor brightness, output volume, mic volume) with output/input device
  pickers underneath, plus a per-app playback page with inline volume/mute.
  Adds `_Shared/Components/VFader.qml` and the `_Shared/Singletons/Display.qml`
  singleton (ddcutil brightness). Wired as a pill surface with a hover glyph and
  `mixer` IPC; Ame docks on the focused fader.
- **Clipboard surface** — `ThePillClipboard.qml` over a warm `Cliphist`
  snapshot: search, keyboard selection, image thumbnails, per-row delete and
  hold-to-wipe. `SUPER+V` opens it; the separate wofi pipeline is gone.
- **Media surface** — `ThePillMedia.qml` with blurred art bleed, marquee
  title/artist, transport controls, a progress line that waves while playing,
  and a source picker when more than one player is live. A circular album-art
  bud on the hover pill opens it; `SUPER+M` does the same. `Players` replaces
  the old single-player `MprisState`.
- **Pill OSD** — the pill morphs briefly for sink volume/mute and for the
  active player's play/pause/track changes (1.2 s linger). Volume is observed
  from PipeWire, so any source produces feedback; the OSD also shows over
  fullscreen video.
- **Window and calculator providers** — `@` lists open windows by
  `focusHistoryID` with app icon, title and workspace; `=` evaluates arithmetic
  through the safe parser in `lib/calc.js`, and bare expressions are
  auto-detected. Enter on a result copies it.
- **Rule-derived workspace dots** — `Workspaces.qml` reads
  `hyprctl workspacerules -j` instead of hardcoding `DP-2`/`HDMI-A-2`, falling
  back to the live workspaces on that monitor.
- **Tray keyboard navigation** — the tray menu tracks one flat selection over
  top-level rows and the expanded submenu: Up/Down or j/k move, Enter activates,
  Right/Left or l/h expand/collapse, Escape closes, separators and disabled rows
  are skipped.
- **Notification window matching** — `Notifs.raiseWindow` matches the Hyprland
  model directly instead of forking `hyprctl clients | jq` per click.
- **Structural cleanup** — removed the unreachable old bar and its widgets,
  renamed the entry `BarTest.qml` → `PillShell.qml`, and deleted the unused
  `SysMetrics`/`ThemeBackup`/`MediaSurface` files.

## Backlog

## 1. Launcher — follow-ups

- Discover providers dynamically instead of the hard-coded `>` `:` `@` `=`
  switch.
- Per-provider glyph/hint chips rather than one placeholder line.
- Wallpaper picker provider (or surface).
- Optional calculator history or unit conversion.

## 2. Rest-pill audio visualiser

The original random-bar indicator is back: a real PipeWire peak visualiser felt
busier and more distracting. If it is revisited, keep it calm — fewer bars,
slower easing, and only while something is actually playing. A true spectrum
(cava) is an option if amplitude bars are not enough; `PwNodePeakMonitor` only
gives per-channel peaks.

## 3. Media — follow-ups

- Seek/source-picker polish for players that report a length. Some
  Firefox/YouTube videos expose no `mpris:length` (the flag is per-video), so
  those have no scrubber.
- Optional "raise player app" action from the media card.

## 4. Mixer / monitors

- DDC validation: the ARZOPA panel (bus 7) returns `EIO` on `getvcp`, but
  `Display.detect()` still lists it, so its brightness fader is dead. Probe each
  monitor and drop failures.
- Brightness keys are intentionally unbound: there is no internal backlight,
  `brightnessctl` is missing, and only the Acer answers DDC.

## 5. Notifications

- `mutedApps` is memory-only by choice; persist it in `Flags` if losing mutes
  on a shell restart becomes annoying.
- `seenIds` is ephemeral; history survives reloads through the runtime dir.

## 6. Performance / testing

- Add a small `scripts/test-quickshell.sh` wrapper around the load test and the
  `lib` JS checks if the harness loop grows.
