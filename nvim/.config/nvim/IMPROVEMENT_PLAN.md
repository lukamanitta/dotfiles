# Neovim Config Improvement Plan

Last updated: 2026-10-29

Scope: `~/.config/nvim`

This document tracks the review of the Neovim config. It separates completed
work, the remaining W8 sweep, and the measurements used to judge whether the
work actually helped. W2–W7 are implemented.

## Decisions

- Keep plugin specs modular: each `plugin/<name>/init.lua` installs the plugin
  and its own dependencies. Do not centralise specs into one manifest.
- Keep keymaps local to their plugin/settings module. Do not centralise them.
- `lua/ui/set_colourscheme.lua` and `lua/ui/palettes/colourme.lua` are generated
  by `colourme`. Edit the templates in
  `colourme/.config/colourme/templates/nvim.lua` and `nvim-base16.lua`, not the
  generated files.
- Lazy loading is not a goal. `vim.pack` loads plugins at startup by design and
  the current startup time is acceptable; the priority is removing blocking
  work from startup and high-frequency code paths.

## Baseline measurements

These are the pre-optimisation numbers. Keep the same methodology for the
post-optimisation comparison.

### Startup

Command:

```sh
nvim --startuptime /tmp/nvim-startup.log --headless +qa
```

Observed:

| Run | Total startup |
| --- | ---: |
| First cold run, before amendments | 57.2 ms |
| First cold run, after amendments (sidekick removed) | 51.5 ms |
| Warm, 10 runs, after amendments | median 42.5 ms, mean 42.6 ms, min 40.5 ms, max 45.4 ms |

Warm run details: `45.4, 42.5, 42.6, 42.3, 44.2, 43.0, 41.9, 40.5, 42.4, 41.1` ms.

Top startup entries after amendments (from the warm logs):

- `plugin/blink-cmp/init.lua`: ~9.8 ms cold, ~5.0 ms self
- `plugin/mason/init.lua`: ~8.4 ms cold, ~6.0 ms self
- `plugin/treesitter/nvim_treesitter.lua`: ~3.2 ms cold, ~1.7 ms self
- `plugin/mini-surround/init.lua`: ~2.8 ms cold
- `plugin/telescope/init.lua`: ~2.1 ms cold

Note: plugin load times vary significantly between runs because of filesystem
cache and the synchronous work discussed in W2.

Raw logs are in `profile/`:

- `startup-baseline.log` (cold, before amendments)
- `startup-after-amendments.log` (cold, after amendments)
- `startup-baseline-warm.log` (one representative warm pre-W2 run)
- `startup-after-w2.log` (cold, after W2)
- `startup-after-w2-warm.log` (one representative warm post-W2 run)
- `startup-after-w3-w4-warm.log` (one representative warm post-W3/W4 run)

The `*.log` files are ignored by the global gitignore (`*.log`).

### Statusline and diagnostics

Command:

```sh
nvim --headless +'luafile profile/bench_statusline.lua' +qa!
```

Benchmark: 10,000 iterations, 100-line buffer, cursor on line 50, no diagnostics.

| Measurement | Before amendments | After amendments (pre-W2) |
| --- | ---: | ---: |
| `statusline.render()` | 54.4 ms total, 5.44 us/call | 55.2 ms total, 5.52 us/call |
| 4x `vim.diagnostic.get(nil, ...)` | 26.9 ms total, 2.69 us/call | 26.5 ms total, 2.65 us/call |

These are best-case numbers with zero diagnostics. `vim.diagnostic.get(nil, ...)`
scales with the number of diagnostics and buffers, so real-world statusline
cost will be higher.

### External process costs

Measured outside Neovim, median of 30 runs:

| Command | Median |
| --- | ---: |
| `git rev-parse --abbrev-ref HEAD` | 0.84 ms |
| `hyprctl -j clients` | 1.93 ms |
| `hyprctl -j clients \| jq ...` | 2.10 ms |

Before W2, the Hypr scratch handler ran two `hyprctl` commands per event, so it
blocked for roughly 4–5 ms per keystroke before shell/fork overhead.

## Completed amendments

- [x] Remove `sidekick.nvim`.
  - Deleted `plugin/sidekick/`.
  - Removed the plugin from `nvim-pack-lock.json` via `vim.pack.del`.
- [x] Add `Staged` git icon.
  - `lua/ui/icons.lua`: solid uses `I.general.CheckCircle`, outline uses
    `I.general.CheckCircleOutline`, text uses `"S"`.
  - Fixes `plugin/neo-tree/init.lua` using `icons.git.Staged` (previously `nil`).
- [x] Add Ayu colourscheme support.
  - New `plugin/colourscheme/ayu.lua` using
    `https://github.com/Shatur/neovim-ayu`.
  - `colourme` already produces `vim.g.colourscheme = "Ayu"` for AyuLight.

## Work items

### W2 — Remove blocking work from startup and hot paths

Status: implemented.

#### W2a — Treesitter install/update

File: `plugin/treesitter/nvim_treesitter.lua`

- Removed the startup `install(...):wait()` and `update():wait()` calls.
- Startup now compares the wanted parser list with `get_installed()` and calls
  `install(missing)` only when something is missing. Installation is
  asynchronous and reports via `vim.notify`.
- After a first-time install, already-open buffers are re-scanned and treesitter
  highlighting is started for supported filetypes.
- Added a startup update prompt when the last successful update is older than
  7 days. Choosing "Later" snoozes the prompt for 24 hours. The prompt is
  skipped in headless/scripted Neovim.
- State is stored in `stdpath("state")/nvim-treesitter-update.json`.
- Running `:TSUpdate` manually also refreshes the timestamp through the
  `User TSUpdate` autocmd.
- Updates run asynchronously; the prompt does not block startup waiting for
  network access.

#### W2b — Hypr scratch resize

File: `lua/settings/autocmds.lua`

Root cause of the breakage: Hyprland 0.56 with a Lua config no longer accepts
the legacy `hyprctl dispatch resizewindowpixel` / `centerwindow` dispatchers.
`hyprctl dispatch` now expects an `hl.dsp.*` expression, so the old command was
silently failing.

The new implementation:

- Uses `hyprctl eval` with `hl.get_window("title:^scratch$")`,
  `hl.dsp.window.resize`, and `hl.dsp.window.center`.
- Gets the actual window width from Hyprland (`w.size.x`) and only changes the
  height, so wrapping width stays stable.
- Uses `nvim_win_text_height(0, { start_row = 0, max_height = 30 }).all` for the
  visual line count, so wrapped lines and folds are counted correctly. The
  `max_height` cap stops scanning once the window's maximum height is reached.
- Resizes immediately when the visual line count changes (no post-typing
  debounce); repeated changes while a resize is in flight are coalesced to the
  latest height.
- Runs `hyprctl` asynchronously with `vim.system`; no shell pipeline and no
  `jq`.

#### W2c — Git branch lookup

File: `lua/ui/statusline/components/git_head_component.lua`

- Replaced the synchronous `git` call with async `vim.system` using
  `git -C <root> rev-parse --abbrev-ref HEAD`.
- Refreshes on `VimEnter`, `DirChanged`, `BufEnter`, and `BufWinEnter`, but only
  when the current buffer's git root (or cwd for non-repos) changes.
- Opening a file from another repository updates the statusline branch.
- Falls back to the folder name when git is unavailable or the path is not a
  repository.

#### W2d — Diagnostic counts

File: `lua/ui/statusline/components/lsp_diagnostics_component.lua`

- Counts are now current-buffer only.
- `render()` reads a cached table; it performs no diagnostic scans.
- The cache is refreshed with a single `vim.diagnostic.count(bufnr)` call on
  `DiagnosticChanged` and `BufEnter`.
- Zero-count severities are still omitted from the rendered statusline.

#### W2e — Related redraw work

- `lua/ui/statusline/init.lua`: component functions are bound once at module
  load, and the nested `table.concat` was simplified.
- `lua/ui/winbar.lua`: `Winbar` highlight is set once at module load instead of
  on every render.
- `lua/ui/statusline/components/mode_component.lua`: mode table hoisted out of
  the render function.
- `lua/ui/init.lua`: `vim.g.icon_style` is set before requiring UI modules.
- `plugin/which-key/init.lua`: `timeoutlen` changed from 3000 to 500 ms.
- `filetype_component.lua` and `lsp_server_name.lua` also cache their module
  lookups; server names now refresh on `BufEnter` as well.

Post-W2 measurements (same methodology as the baseline):

| Measurement | Before W2 | After W2 |
| --- | ---: | ---: |
| Warm startup, 10 runs | median 42.5 ms | median 40.5 ms |
| `statusline.render()` | 5.44 us/call | ~1.7 us/call |
| Startup update/install wait | up to 300 s per call | none when parsers exist |
| Hypr scratch per keystroke | ~4–5 ms blocking + shell/jq | async, only on visual-line change |
| Git branch lookup | ~0.84 ms blocking per event | async, root-aware |

The benchmark also measures the old `4x vim.diagnostic.get(nil, ...)` path at
~2.7 us/call for reference, but the statusline no longer uses that path.

### W3 — Colourscheme and plugin themes

Status: implemented.

Previous behaviour depended on alphabetical plugin load order and required every
scheme handler to call `require("ui.colourscheme_common")()` manually. Runtime
`:colorscheme` changes did not re-run common or plugin theme setup.

Implemented:

- Added `lua/ui/theme.lua`, a small theme registry plus a `ColorScheme` autocmd.
- `lua/ui/init.lua` now loads `ui.theme` instead of the dead
  `ui.colourscheme_common` require.
- Removed all manual `require("ui.colourscheme_common")()` calls from
  `plugin/colourscheme/*.lua`.
- Plugin themes in `plugin/fff`, `plugin/neo-tree`, `plugin/telescope`, and
  `plugin/treesitter` now register a function with `ui.theme` instead of running
  immediately. Theme functions recompute highlight values when called, so a
  runtime `ColorScheme` gets the new scheme's colours.
- Added a `VimEnter` pass because plugin theme files register after the startup
  colourscheme has already been applied.
- Fixed `TreeSitterContextSeparator` → `TreesitterContextSeparator` in
  `lua/ui/colourscheme_common.lua`.
- Deleted `plugin/outline/theme.lua`; it was a copy of the Treesitter theme and
  set `TreesitterContext`, not an Outline group.
- Scheme-specific tweaks in gruvbox/mini-base16/kanagawa remain local to their
  handlers.

Verified by forcing `doautocmd ColorScheme` and confirming plugin theme
highlights are reapplied, and by checking `TreesitterContext` / `FFFGitStaged`
links after startup.

### W4 — Statusline cleanup

Status: implemented.

- Added `lua/ui/statusline/hl.lua` with an `hl(group, text)` helper.
- Updated diagnostics, server name, filetype, and mode components to use it.
- Simplified `position_component.lua` to the format string it actually returns.
- Made `file_progress_component.lua` safe for `line_count == 0` and clamped the
  indicator index.
- Warm startup after W3/W4 measured at 41.6 ms median, within run-to-run noise
  of the 40.5 ms post-W2 result.

### W5 — Dead code and broken files

Status: implemented.

- Deleted unused legacy syntax/indent files for JFlex, Dafny, and pseudo:
  - `after/syntax/{jflex,dafny,pseudo}.vim`
  - `after/indent/pseudo.vim`
  - `after/ftplugin/dafny.vim`
- Deleted `after/syntax/markdown.vim` (Markdown conceal/strikethrough) because
  the legacy syntax path was inactive; a treesitter-based solution can replace
  it later if needed. `after/ftplugin/markdown/markdown.vim` remains.
- Deleted unused `after/ftplugin/gdscript.lua` and
  `after/ftplugin/markdown/unilatex.vim`.
- Deleted empty `after/lsp/*.lua` stubs that only returned `{}`.
- Deleted empty colourscheme stubs (`cole`, `monochrome`, `zenbones`) and
  comment-only `plugin/oil/{keymaps,theme}.lua`.
- Removed stale commented blocks from `settings/autocmds.lua`,
  `plugin/colourscheme/kanagawa.lua`, `plugin/telescope/keymaps.lua`, and
  `init.lua`.
- Kept `minimal-init.lua` and documented it as an emergency fallback.
- Renamed `plugin/_template/*.lua` to `*.lua.template` so the recursive
  `plugin/**/*.lua` loader does not source them. They remain in the same
  directory for copy-paste.

### W6 — Helper module cleanup

Status: implemented.

- Removed unused `table_has_value`, `table_merge`, and `get_buf_icon_colour`
  from `lua/h.lua`.
- Removed the pointless `nvim_get_hl(..., create = true)` call from `set_hl`.
- Kept `h.lua` as one module; future splitting/renaming is optional.
- Moved `nvim-web-devicons` installation into
  `plugin/devicons/init.lua`, removing the plugin side effect from `h.lua`.

### W7 — Correctness and consistency fixes

Status: implemented.

- Conform: JS/TS/JSX/TSX now use `{ "eslint_d", "prettierd" }`; HTML/CSS/SCSS/
  JSON/Svelte use `{ "prettierd" }`.
- 80-column marker: replaced the global `matchadd` with
  `lua/settings/colorcolumn.lua`, which adds a window-local match to normal
  windows. `ColorColumn` now uses the `CursorLine` background, falling back to
  `Visual` when that is unset or equal to `Normal`.
- Fish `iskeyword` ftplugin removed; it was global and redundant.
- Removed the Markdown `matchadd`/global `conceallevel` file along with the
  inactive legacy syntax path.
- Kept `exrc = true`; Neovim only loads trusted project configs, and the option
  is now commented accordingly.
- Removed the custom `packpath` override from `init.lua`; the default packpath
  already includes the `vim.pack` directory.
- LSP: semantic tokens are disabled cleanly via
  `vim.lsp.semantic_tokens.enable(false)`; inlay hints are buffer-local.
- Keymaps: normalised to `<LEADER>` and `:cmd<CR>`, added `desc` metadata across
  settings, LSP, DAP, FFF, Hop, Neo-tree, Outline, Telescope, and Copilot
  mappings.
- Installed `stylua 2.6.0` via mise and ran `stylua .` across the config.

### W8 — Post-W7 sweep (planned)

Status: not started. These are findings from a second review after W7.

High priority:

- Fix `lua/h.lua` `mod_hl`: it currently reads linked groups and then adds
  attributes, but `link` wins, so the change is discarded for linked groups.
  Fetch with `{ link = false }` or resolve the link before modifying.
- Resolve Telescope theme override ordering. `plugin/telescope/theme.lua` applies
  generic Telescope colours after scheme-specific overrides, so Kanagawa and
  Tokyo Night Telescope colours are overwritten. Either remove the generic theme
  or give scheme-specific themes higher priority.
- FFF live grep root: `base_path` is pinned to the startup cwd, while
  `find_files` passes the current git root and `live_grep` does not. Pass
  `cwd = require("h").git_root_or_cwd()` to live grep as well; consider
  `wait_for_index_ms = 0` to avoid blocking during reindex.
- Remove FFF resume-cursor dead code. `last_row` is never assigned and the
  `BufEnter` autocmd fires for picker buffers, not the selected file.
- Filter `PackChanged` hooks by `ev.data.kind` (`install`/`update`) in Blink,
  FFF, Hexokinase, and Telescope. Building on `delete` is wrong.

Cleanup and structure:

- Delete unused `lua/lib/telescope_finders.lua` and
  `lua/ui/statusline/components/position_component.lua`.
- Use `ui.icons.types` for `plugin/outline/init.lua`, or remove `I.types` if it
  will not be used. This also removes Outline's dependency on the private Blink
  appearance module.
- Simplify `mode_component`: the `mini.statusline` branch is dead and the
  fallback is `RedrawDebugNormal`. Define proper mode groups or use a stable
  existing group.
- Trim `plugin/dap/dap_ui.lua` and `plugin/dap/dap_virtual_text.lua` to
  intentional overrides instead of restating plugin defaults and upstream
  comments.
- Extract the ~100-line Hypr scratch block from `lua/settings/autocmds.lua` into
  its own module.
- Generate the repeated FFF git highlight groups with a small mapping table.
- Deduplicate colourscheme helpers:
  - diagnostic-sign background loops in gruvbox/mini-base16/kanagawa
  - git-sign background loops in mini-base16/kanagawa
  - Rose Pine and Tokyo Night variant branching
- Table-drive the repeated link definitions in `lua/ui/colourscheme_common.lua`.
- Convert the raw `TermClose` command string in `lua/settings/autocmds.lua` to an
  autocmd callback using `nvim_buf_delete`.
- Add `clear = true` to the `jump_to_last_pos`, `yank_highlight`, `ui/winbar`,
  and `plugin/outline/autocmds` augroups.
- `lua/ui/winbar.lua`: use `relative == ""` instead of `not zindex`, handle
  unnamed buffers, and consider adding `WinEnter`.
- Review `plugin/colourscheme/coal.lua`: `WarningMsg` uses the hint colour and
  `OkMsg` is a nonstandard unused group.
- Review the custom if-statement surrounding in `plugin/mini-surround/init.lua`;
  it is hardcoded to one tree-sitter node and may be unused.
- Optionally split `lua/h.lua` into table/highlight/buffer helpers.
- Conditionally add `/usr/share/hypr/stubs` in `after/lsp/lua_ls.lua` only when
  the directory exists.
- Remove stale commented LSP setup in `lua/lsp/init.lua`.

Performance/UX:

- FFF reindexing can block up to 10 seconds when `cwd` changes; decide whether
  to use `wait_for_index_ms = 0`.
- Consider `update_in_insert = false` in `lua/lsp/theme.lua` if diagnostics feel
  noisy while typing.
- Outline's private Blink require adds startup coupling; using `ui.icons.types`
  should simplify it.

Suggested first batch: `mod_hl` fix, Telescope theme ordering, FFF root/resume
cleanup, delete unused files, use `ui.icons.types`, and PackChanged kind
filtering.

## Reproducing the benchmarks

```sh
# Startup
nvim --startuptime /tmp/nvim-startup.log --headless +qa

# Statusline + diagnostics
nvim --headless +'luafile profile/bench_statusline.lua' +qa!

# External process timings
python3 - <<'PY'
import subprocess, time, statistics
def bench(cmd, n=30):
    times = []
    for _ in range(n):
        t = time.perf_counter()
        subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL)
        times.append((time.perf_counter() - t) * 1000)
    print(f"{cmd!r}: median {statistics.median(times):.2f} ms")
bench("git rev-parse --abbrev-ref HEAD")
bench("hyprctl -j clients")
PY
```
