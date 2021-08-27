local wezterm = require 'wezterm'
local osPathSep = package.config:sub(1,1)
local onWindows = osPathSep == "\\"
local cfg = {
    --General--

    warn_about_missing_glyphs = true,
    window_background_opacity = 1.0,
    native_macos_fullscreen_mode=true,
    initial_cols = 90,
    intial_rows = 28,

    --color_scheme = "Batman",
    --color_scheme = "Dracula+",
    --color_scheme = "MaterialDarker",
    --color_scheme = "Overnight Slumber",
    color_scheme = "Tinacious Design (Dark)",
    --color_scheme = "Tomorrow Night Eighties",

    tab_bar_at_bottom=true,
    enable_kitty_graphics=true,

    --General--

    --Fonts--

    font_dirs = {"~/dotfiles/fonts", "~/dotfiles/fonts/RobotoMono"},

    font = wezterm.font("RobotoMono Nerd Font"),
    font_size = 14,

    --Fonts--

    --Keybindings--

    leader = {key="a", mods="SUPER", timeout_milliseconds=1000},

    send_composed_key_when_left_alt_is_pressed=true,
    send_composed_key_when_right_alt_is_pressed=false,

    keys = {
      --- Keybindings for Multiplex
      {key="s", mods="LEADER", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
      {key="-", mods="LEADER", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
      {key="|", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Left"}},
      {key="j", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Down"}},
      {key="k", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Up"}},
      {key="l", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Right"}},
      {key="x", mods="LEADER", action=wezterm.action{CloseCurrentPane={confirm=false}}},
      {key="Enter", mods="LEADER", action="TogglePaneZoomState"},

      --- Keybindings for Tabs
      {key="c", mods="LEADER", action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
      {key="w", mods="LEADER", action=wezterm.action{CloseCurrentTab={confirm=true}}},
    },

    --Keybindings--
}

if onWindows then
    cfg.default_prog = {'wsl', '~'} --Start linux subsystem and go to linux home dir
end

-- Tab switching keys (saves repeating essentially the same keybinding 10 times)
for tabNum = 1, 9 do
    table.insert(cfg.keys, {key=tostring(tabNum), mods="LEADER", action=wezterm.action{ActivateTab=tabNum-1}})
end

return cfg

--NOT WORKING ON WINDOWS
--local keybindings = require 'lua/keybindings'
--local helper = require 'lua/helpers'.helper

----- Misc Config
--local cfg_general = require 'lua/general'

----- Font Config
--local cfg_fonts = require 'lua/fonts'

----- Keybind Config
--local cfg_keybindings = require 'lua/keybindings'

----- Combined Config
--local config = helper.combine_config(
  --cfg_general,
  --cfg_fonts,
  --cfg_keybindings,
  --{}
--)
--
--return config
