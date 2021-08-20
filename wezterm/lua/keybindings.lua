local wezterm = require 'wezterm'

local cfg = {}

--send_composed_key_when_left_alt_is_pressed=true,
--send_composed_key_when_right_alt_is_pressed=false,

cfg.leader = {
  key="a", mods="ALT", timeout_milliseconds=10000
}

cfg.keys = {
  --- Keybindings for Multiplex
  {key="s", mods="LEADER", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
  {key="v", mods="LEADER", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
  {key="h", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Left"}},
  {key="j", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Down"}},
  {key="k", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Up"}},
  {key="l", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Right"}},
  {key="x", mods="LEADER", action=wezterm.action{CloseCurrentPane={confirm=true}}},
  {key="Enter", mods="LEADER", action="TogglePaneZoomState"},

  --- Keybindings for Tabs
  {key="t", mods="LEADER", action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
  {key="w", mods="LEADER", action=wezterm.action{CloseCurrentTab={confirm=true}}},
  {key="1", mods="LEADER", action=wezterm.action{ActivateTab=0}},
  {key="2", mods="LEADER", action=wezterm.action{ActivateTab=1}},
  {key="3", mods="LEADER", action=wezterm.action{ActivateTab=2}},
  {key="4", mods="LEADER", action=wezterm.action{ActivateTab=3}},
  {key="5", mods="LEADER", action=wezterm.action{ActivateTab=4}},
  {key="6", mods="LEADER", action=wezterm.action{ActivateTab=5}},
  {key="7", mods="LEADER", action=wezterm.action{ActivateTab=6}},
}

return cfg
