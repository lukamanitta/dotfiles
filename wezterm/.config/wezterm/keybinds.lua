local wezterm = require("wezterm")

local U = {
   --- Keybindings for Multiplex
   {
       key = "/",
       mods = "LEADER",
       action = wezterm.action({
           SplitHorizontal = { domain = "CurrentPaneDomain" },
       }),
   },
   {
       key = "-",
       mods = "LEADER",
       action = wezterm.action({
           SplitVertical = { domain = "CurrentPaneDomain" },
       }),
   },
   {
       key = "h",
       mods = "LEADER",
       action = wezterm.action({ ActivatePaneDirection = "Left" }),
   },
   {
       key = "j",
       mods = "LEADER",
       action = wezterm.action({ ActivatePaneDirection = "Down" }),
   },
   {
       key = "k",
       mods = "LEADER",
       action = wezterm.action({ ActivatePaneDirection = "Up" }),
   },
   {
       key = "l",
       mods = "LEADER",
       action = wezterm.action({ ActivatePaneDirection = "Right" }),
   },
   {
       key = "x",
       mods = "LEADER",
       action = wezterm.action({ CloseCurrentPane = { confirm = false } }),
   },
   {
       key = "Enter",
       mods = "LEADER",
       action = "TogglePaneZoomState",
   },

   --- Keybindings for Tabs
   {
       key = "t",
       mods = "LEADER",
       action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
   },
   {
       key = "w",
       mods = "LEADER",
       action = wezterm.action({ CloseCurrentTab = { confirm = true } }),
   },
   {
       key = "]",
       mods = "LEADER",
       action = wezterm.action({ ActivateTabRelative = 1 }),
   },
   {
       key = "[",
       mods = "LEADER",
       action = wezterm.action({ ActivateTabRelative = -1 }),
   },
}

-- Tab switching keys (saves repeating essentially the same keybinding 10 times)
for tabNum = 1, 9 do
    table.insert(U, {
        key = tostring(tabNum),
        mods = "LEADER",
        action = wezterm.action({ ActivateTab = tabNum - 1 }),
    })
end

return U
