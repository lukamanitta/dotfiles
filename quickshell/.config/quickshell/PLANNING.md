# Quickshell planning

Ideas and their status. **Done** items are implemented; the rest are backlog.

## Done

- **Command palette** — `_Shared/Components/Palette.qml` is a reusable
  search + result-list component; `ThePillLauncher` hosts three providers
  switched by a prefix: apps (default), `>` commands (open surfaces, toggles)
  and `:` flags (DND, notification position).
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

## Backlog

## 1. Command palette — follow-ups

The shell-palette refactor is in. Possible extensions:

- More providers (window switching via Hyprland clients, clipboard history,
  wallpaper picker).
- Discover providers dynamically instead of the hard-coded prefix switch.
- Per-provider glyph/hint chips rather than the single hint line.

## 2. Better audio visualiser in the collapsed pill

The collapsed pill currently shows a small `AudioIndicator` next to the clock.

- Replace/upgrade with a proper level/spectrum visualiser (e.g. a compact cava
  or PipeWire peak-driven bar set) that fits the rest pill footprint.
- Must respect the Ame/`Motion` language (no harsh motion), degrade gracefully
  when nothing is playing, and stay cheap enough for 24/7 (no full-rate
  repaint unless playing).
- Decide placement: in place of the current audio glyph, or integrated with the
  rest row hero.

