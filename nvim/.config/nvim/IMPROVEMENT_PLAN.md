# Neovim Config Improvement Plan

Last updated: 2026-10-29

Scope: `~/.config/nvim`

This document tracks the review of the Neovim config. It separates completed
work, remaining proposals, and the measurements used to judge whether the work
actually helped. W2–W4 are implemented; W5–W7 are the remaining backlog.

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

- Delete `after/ftplugin/markdown/unilatex.vim` (~1661 lines, entirely
  commented).
- Delete `after/ftplugin/gdscript.lua` (comments only).
- Delete or rewrite `after/indent/pseudo.vim`; it uses `python#GetIndent` and
  guards on a different function name, and there is no pseudo ftdetect.
- Remove empty stubs: `plugin/colourscheme/{cole,monochrome,zenbones}.lua`,
  empty `plugin/*/theme.lua` files, and commented-only keymap files.
- Move `plugin/_template/` out of `plugin/`; `plugin/**/*.lua` is recursive, so
  the template is loaded at startup despite the underscore.
- Remove stale commented blocks: `settings/autocmds.lua:1-15`,
  `telescope/keymaps.lua`, `kanagawa.lua:54-62`, `minimal-init.lua` (or keep
  `minimal-init.lua` explicitly as a fallback and document it).
- Remove empty `after/lsp/*.lua` configs that only `return {}`, keeping the
  ones with real settings.

### W6 — Helper module cleanup

File: `lua/h.lua`

- `table_has_value`: remove the always-false `if t == {}` check; use
  `vim.tbl_contains`.
- `table_merge`: unused; remove and use `vim.tbl_deep_extend` if needed.
- `set_hl`: remove the unused `nvim_get_hl(..., create = true)` call.
- `get_buf_icon_colour`: unused and duplicates `get_buf_icon`; merge or remove.
- `h.lua` currently calls `vim.pack.add` for devicons; move that side effect into
  a plugin init file. Utility modules should not install plugins.
- Consider splitting into `lib/table.lua`, `lib/highlight.lua`, and
  `lib/buffer.lua`; rename `h` to something descriptive if the require churn is
  acceptable.

### W7 — Correctness and consistency fixes

- `plugin/conform/init.lua:33-53`: the prettierd loop overwrites `eslint_d` for
  JavaScript/TypeScript. Define the desired formatter lists explicitly.
- `lua/settings/options.lua:38` + `colourscheme_common.lua:17`: the 80-column
  `matchadd` is window-local, and `ColorColumn` is linked to `Normal`, so the
  marker is invisible. Prefer `vim.opt.colorcolumn = "80"` with a visible
  `ColorColumn` highlight.
- `after/ftplugin/fish.lua:1`: uses global `vim.opt.iskeyword`; use
  `vim.opt_local` or remove it because `options.lua:36` already removes `_`.
- `after/syntax/markdown.vim`: `matchadd` is window-local and leaks across
  buffers; `conceallevel` is set globally. Use `setlocal` and buffer/syntax
  regions. Also verify whether these `after/syntax` files run at all while
  `syntax = "off"` and treesitter is active.
- `lua/settings/options.lua:32`: revisit `exrc = true` from a security
  perspective.
- `init.lua:4`: `set packpath=` replaces the default packpath; prefer
  `vim.opt.packpath:append(...)`.
- `lsp/init.lua:44-50`: make inlay hints buffer-local and avoid mutating
  `client.server_capabilities.semanticTokensProvider` after attach.
- Standardise keymap style and add `desc` metadata where missing.
- Run `stylua` (currently not installed in this environment) to normalise the
  files that differ from `.stylua.toml`.

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
