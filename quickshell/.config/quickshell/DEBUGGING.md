# Debugging the pill

The live desktop is Hyprland (Lua config) plus a Quickshell pill/bar. Both are
stow-linked from this repo, so edit the repo paths, not `~/.config`.

Read this before touching the shell or the compositor: it is the test loop,
the toolkit for driving a UI you cannot click, and the Hyprland 0.56 traps
that cost real time to rediscover.

## The loop

1. **Load test** — fastest way to catch a QML error. Run a second instance
   against the config; a clean run never exits, an error prints
   `Failed to load configuration` plus a source line.
   ```
   cd /tmp/opencode && timeout 7 quickshell -p /home/luka/dotfiles/quickshell/.config/quickshell > qs-test.log 2>&1
   ```
   `exit 124` (timeout) = still running = pass. Then:
   `rg -i "error|warn|invalid|failed|not a type|undefined" qs-test.log`
   - Keep `-n` off (it would dedupe the instance) and leave
     `XDG_RUNTIME_DIR` alone (it breaks the Wayland socket).
   - Ignore `qmlls config symlink`, the Sunshine tray icon, and the
     notification-bus ownership warning on the second instance.
   - `qmllint` emits bogus errors on these files; trust the load test.

2. **Restart the live shell** — it does not hot-reload, and it owns
   `org.freedesktop.Notifications`.
   ```
   pkill -x quickshell; sleep 1; setsid quickshell -n -d >/tmp/opencode/qs-run.log 2>&1 </dev/null &
   ```

3. **Read the log** — the live (`-d`) instance writes QML `console.log` to the
   binary qslog, not the redirect file. Add a marked line, then:
   `strings "$(ls -t "$XDG_RUNTIME_DIR"/quickshell/by-id/*/log.qslog | head -1)" | rg -a '=MARK='`
   Load/startup errors also land in `qs-run.log` / `qs-test.log`.

## Driving a UI you cannot click

There is no `wtype`/`ydotool`. Reach into the code instead of synthesising
input:

- **Screenshots** — `grim -g "x,y WxH" /tmp/opencode/shot.png`. Monitors are
  DP-2 at `0,0` and HDMI-A-2 at `0,1080` (both 1920x1080); the pill is
  top-centre of each.
- **IPC** — `qs ipc call pill <fn> [args]`; the surface helper resolves the
  focused monitor: `~/.config/hypr/scripts/open-pill-surface.sh <name>`. Add a
  temporary `IpcHandler` function to trigger a code path on demand.
- **Auto-fire a real action** — a temporary `Timer` inside a surface
  (`running: root.active`, `onTriggered: root.<action>()`) exercises the exact
  activation path, keyboard focus and all. This is how the launcher's
  placement/focus behaviour was pinned down.
- **Component harness** — drop `_ztest.qml` in the config dir: a `ShellRoot`
  with a `Timer` that inspects a service, prints via `console.log`, then
  `Qt.quit()`. Point the load test at that file, read the output, delete it.
  (Used to learn PipeWire's `isSink`/`isStream`/`type` for the mixer.)

## Hyprland 0.56 (Lua config) changed the commands

- Dispatches are Lua now. Legacy syntax fails:
  - `hyprctl dispatch workspace 3` → `')' expected near '3'`
  - `hyprctl dispatch 'hl.dsp.focus({ workspace = 3 })'`
  - From Quickshell: `Hyprland.dispatch('hl.dsp.focus({ workspace = "3" })')`
- `hyprctl keyword` is dead for these options (`keyword can't work with
  non-legacy parsers. Use eval.`). Change runtime values with:
  `hyprctl eval 'hl.config({ misc = { mouse_move_focuses_monitor = false } })'`
- Read effective values: `hyprctl getoption misc:initial_workspace_tracking`.
- `hyprctl activeworkspace` reports the **focused monitor's** workspace, not
  the one under the cursor.
- To settle a behaviour question, read the exact source instead of guessing:
  `curl -sL https://github.com/hyprwm/Hyprland/archive/refs/tags/v0.56.2.tar.gz | tar xz`
  then `rg` it. Option semantics live in the wiki repo at
  `content/configuring/core/config-options.md`.

## Traps that cost time

- **An empty workspace won't focus across monitors.** `cursor:no_warps = true`
  together with `misc:mouse_move_focuses_monitor = true` makes focus snap back
  to the cursor's monitor, so switching to an *empty* workspace on another
  monitor silently fails (a workspace holding a window masks it). Keep
  `mouse_move_focuses_monitor = false`; keep `no_warps = true` when the cursor
  must stay put.
- **Launcher-opened apps land and focus wrong.** A layer surface releasing
  keyboard focus hands it back to the last window, often on another monitor;
  an app that maps afterwards opens there and stays unfocused. The launcher
  routes app launches through Hyprland's executor (`hl.dsp.exec_cmd`,
  workspace-stamped via `misc:initial_workspace_tracking`) and re-focuses the
  target workspace shortly after. See `ThePillLauncher.qml`.
- **Qt Wayland auto-repeat** delivers a `KeyRelease` *and* a `KeyPress` per
  repeat, both `isAutoRepeat = true`; the real release is
  `isAutoRepeat = false`. Filter `e.isAutoRepeat` for press/release holds
  instead of timing heuristics (`qwaylandinputdevice.cpp`).

## Leave the session as you found it

Tests move workspaces and the cursor. Before finishing, restore the user's
workspace (`hl.dsp.focus({ workspace = ... })`) and cursor
(`hl.dsp.cursor.move({ x = ..., y = ... })`), and close any window you spawned
(`hl.dsp.window.close({ window = "address:0x..." })`).
