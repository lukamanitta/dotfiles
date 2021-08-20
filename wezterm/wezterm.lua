local wezterm = require 'wezterm'
local cfg = {
    --General--

    warn_about_missing_glyphs = false,
    window_background_opacity = 1.0,

    --color_scheme = "Batman",
    --color_scheme = "Dracula+",
    --color_scheme = "MaterialDarker",
    color_scheme = "Overnight Slumber",
    --color_scheme = "Tinacious Design (Dark)",
    --color_scheme = "Tomorrow Night Eighties",

    --General--

    --Fonts--

    font = wezterm.font("APL386 Nerd Font"),
    font_size = 14.0,

    --Fonts--

    --Keybindings--

    leader = {key="a", mods="ALT", timeout_milliseconds=1000},

    keys = {
      --- Keybindings for Multiplex
      {key="s", mods="LEADER", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
      {key="v", mods="LEADER", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
      {key="h", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Left"}},
      {key="j", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Down"}},
      {key="k", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Up"}},
      {key="l", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Right"}},
      {key="x", mods="LEADER", action=wezterm.action{CloseCurrentPane={confirm=false}}},
      {key="Enter", mods="LEADER", action="TogglePaneZoomState"},

      --- Keybindings for Tabs
      {key="c", mods="LEADER", action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
      {key="w", mods="LEADER", action=wezterm.action{CloseCurrentTab={confirm=true}}},
      {key="1", mods="LEADER", action=wezterm.action{ActivateTab=0}},
      {key="2", mods="LEADER", action=wezterm.action{ActivateTab=1}},
      {key="3", mods="LEADER", action=wezterm.action{ActivateTab=2}},
      {key="4", mods="LEADER", action=wezterm.action{ActivateTab=3}},
      {key="5", mods="LEADER", action=wezterm.action{ActivateTab=4}},
      {key="6", mods="LEADER", action=wezterm.action{ActivateTab=5}},
      {key="7", mods="LEADER", action=wezterm.action{ActivateTab=6}},
    },

    --Keybindings--
}

if package.config:sub(1,1) == "\\" then
    cfg.default_prog = {'wsl', '~'}
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
