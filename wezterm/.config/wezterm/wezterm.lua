local wezterm = require('wezterm')
local osPathSep = package.config:sub(1, 1)
local onWindows = osPathSep == '\\'
local cfg = {
    --General--

    warn_about_missing_glyphs = true,
    window_background_opacity = 1.0,
    native_macos_fullscreen_mode = true,
    initial_cols = 90,
    intial_rows = 28,

    color_scheme_dirs = { '../colors' },
    color_scheme = 'Test',

    -- color_schemes = require('colors.catppuccino'),
    -- color_scheme = "Dark Catppuccino",

    -- color_scheme = "Batman",
    -- color_scheme = "Dracula+",
    -- color_scheme = "MaterialDarker",
    -- color_scheme = "Overnight Slumber",
    -- color_scheme = "Tinacious Design (Dark)",
    -- color_scheme = "Tomorrow Night Eighties",

    tab_bar_at_bottom = true,
    use_fancy_tab_bar = false,
    tab_max_width = 15,
    enable_kitty_graphics = true,

    default_cursor_style = 'BlinkingBlock',
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },

    --General--

    --Fonts--

    font_dirs = { '~/dotfiles/fonts', '~/dotfiles/fonts/RobotoMono', '~/dotfiles/fonts/Cousine' },

    font = wezterm.font('SourceCodePro Nerd Font'),
    font_size = 14,

    --Fonts--

    --Keybindings--

    leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },

    send_composed_key_when_left_alt_is_pressed = true,
    send_composed_key_when_right_alt_is_pressed = false,

    keys = {
        --- Keybindings for Multiplex
        {
            key = '/',
            mods = 'LEADER',
            action = wezterm.action({ SplitHorizontal = { domain = 'CurrentPaneDomain' } }),
        },
        {
            key = '-',
            mods = 'LEADER',
            action = wezterm.action({ SplitVertical = { domain = 'CurrentPaneDomain' } }),
        },
        {
            key = 'h',
            mods = 'LEADER',
            action = wezterm.action({ ActivatePaneDirection = 'Left' }),
        },
        {
            key = 'j',
            mods = 'LEADER',
            action = wezterm.action({ ActivatePaneDirection = 'Down' }),
        },
        {
            key = 'k',
            mods = 'LEADER',
            action = wezterm.action({ ActivatePaneDirection = 'Up' }),
        },
        {
            key = 'l',
            mods = 'LEADER',
            action = wezterm.action({ ActivatePaneDirection = 'Right' }),
        },
        {
            key = 'x',
            mods = 'LEADER',
            action = wezterm.action({ CloseCurrentPane = { confirm = false } }),
        },
        {
            key = 'Enter',
            mods = 'LEADER',
            action = 'TogglePaneZoomState',
        },

        --- Keybindings for Tabs
        {
            key = 't',
            mods = 'LEADER',
            action = wezterm.action({ SpawnTab = 'CurrentPaneDomain' }),
        },
        {
            key = 'w',
            mods = 'LEADER',
            action = wezterm.action({ CloseCurrentTab = { confirm = true } }),
        },
    },

    --Keybindings--
}

if onWindows then
    cfg.default_prog = { 'wsl', '~' } --Start linux subsystem and go to linux home dir
end

-- Tab switching keys (saves repeating essentially the same keybinding 10 times)
for tabNum = 1, 9 do
    table.insert(cfg.keys, {
        key = tostring(tabNum),
        mods = 'LEADER',
        action = wezterm.action({ ActivateTab = tabNum - 1 }),
    })
end

cfg.colors = {
    background = '#1b1624',
    foreground = '#abb2bf',

    cursor_bg = '#abb2bf',
    cursor_fg = '#1b1624',
    cursor_border = '#abb2bf',

    selection_fg = '#1b1624',
    selection_bg = '#abb2bf',

    scrollbar_thumb = '#abb2bf',

    split = '#2a2e36',

    ansi = {
        '#393b44', -- Black
        '#c94f6d', -- Red
        '#97c374', -- Green
        '#dbc074', -- Yellow
        '#61afef', -- Blue
        '#c678dd', -- Magenta
        '#63cdcf', -- Cyan
        '#dfdfe0', -- White
    },

    brights = {
        '#7f8c98', -- Black
        '#e06c75', -- Red
        '#58cd8b', -- Green
        '#ffe37e', -- Yellow
        '#84cee4', -- Blue
        '#b8a1e3', -- Magenta
        '#59f0ff', -- Cyan
        '#fdebc3', -- White
    },

    indexed = {
        [16] = '#ffe37e',
        [17] = '#e06c75',
    },

    tab_bar = {
        background = '#1b1624',

        active_tab = {
            bg_color = '#1b1624',
            fg_color = '#dfdfe0',

            intensity = 'Bold', -- Half | Normal | Bold
            underline = 'None', -- None | Single | Double
            italic = false,
            strikethrough = false,
        },

        inactive_tab = {
            bg_color = '#1b1624',
            fg_color = '#7f8c98',

            intensity = 'Normal', -- Half | Normal | Bold
            underline = 'None', -- None | Single | Double
            italic = false,
            strikethrough = false,
        },

        inactive_tab_hover = {
            bg_color = '#1b1624',
            fg_color = '#dfdfe0',

            intensity = 'Normal', -- Half | Normal | Bold
            underline = 'None', -- None | Single | Double
            italic = true,
            strikethrough = false,
        },

        -- New tab button
        new_tab = {
            bg_color = '#1b1624',
            fg_color = '#7f8c98',
        },

        new_tab_hover = {
            bg_color = '#1b1624',
            fg_color = '#dfdfe0',

            intensity = 'Bold', -- Half | Normal | Bold
            italic = false,
        },
    },
}

return cfg

-- TODO: factor out config into separate files
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
