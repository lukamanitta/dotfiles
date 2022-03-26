local wezterm = require('wezterm')
local osPathSep = package.config:sub(1, 1)
local onWindows = osPathSep == '\\'
local cfg = {
    --General--

    warn_about_missing_glyphs = true,
    window_background_opacity = 1.0,
    native_macos_fullscreen_mode = true,
    initial_cols = 90,
    initial_rows = 28,

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
    force_reverse_video_cursor = true,

    --Fonts--

    font_dirs = {
        '~/dotfiles/fonts',
        '~/dotfiles/fonts/RobotoMono',
        '~/dotfiles/fonts/Cousine',
        '~/dotfiles/fonts/SourceCodePro',
    },

    font = wezterm.font('SourceCodePro Nerd Font'),
    font_size = 13.5,

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
        {
            key = ']',
            mods = 'LEADER',
            action = wezterm.action({ ActivateTabRelative = 1 }),
        },
        {
            key = '[',
            mods = 'LEADER',
            action = wezterm.action({ ActivateTabRelative = -1 }),
        },
    },
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

local colours = {
    kawagana = {
        foreground = '#dcd7ba',
        background = '#1f1f28',

        cursor_bg = '#c8c093',
        cursor_fg = '#c8c093',
        cursor_border = '#c8c093',

        selection_fg = '#c8c093',
        selection_bg = '#2d4f67',

        scrollbar_thumb = '#16161d',
        split = '#16161d',

        ansi = {
            '#090618',
            '#c34043',
            '#76946a',
            '#c0a36e',
            '#7e9cd8',
            '#957fb8',
            '#6a9589',
            '#c8c093',
        },
        brights = {
            '#727169',
            '#e82424',
            '#98bb6c',
            '#e6c384',
            '#7fb4ca',
            '#938aa9',
            '#7aa89f',
            '#dcd7ba',
        },
    },

    tokyonight_night = {
        background = '#1a1b26',
        foreground = '#c0caf5',

        cursor_bg = '#c0caf5',
        cursor_fg = '#1a1b26',
        cursor_border = '#c0caf5',

        selection_fg = '#c0caf5',
        selection_bg = '#33467c',

        scrollbar_thumb = '#c0caf5',

        split = '#2a2e36',

        ansi = {
            '#15161E', -- Black
            '#f7768e', -- Red
            '#9ece6a', -- Green
            '#e0af68', -- Yellow
            '#7aa2f7', -- Blue
            '#bb9af7', -- Magenta
            '#7dcfff', -- Cyan
            '#a9b1d6', -- White
        },
        brights = {
            '#414868', -- Black
            '#f7768e', -- Red
            '#9ece6a', -- Green
            '#e0af68', -- Yellow
            '#7aa2f7', -- Blue
            '#bb9af7', -- Magenta
            '#7dcfff', -- Cyan
            '#c0caf5', -- White
        },
    },
}

-- TODO: Port all neovim colorschemes to wezterm
local colourscheme = 'kawagana'
cfg.colors = colours[colourscheme]

cfg.colors.tab_bar = {
    background = cfg.colors.background,

    active_tab = {
        bg_color = cfg.colors.background,
        fg_color = cfg.colors.foreground,

        intensity = 'Bold', -- Half | Normal | Bold
        underline = 'None', -- None | Single | Double
        italic = false,
        strikethrough = false,
    },

    inactive_tab = {
        bg_color = cfg.colors.background,
        fg_color = cfg.colors.brights[1],

        intensity = 'Normal', -- Half | Normal | Bold
        underline = 'None', -- None | Single | Double
        italic = false,
        strikethrough = false,
    },

    inactive_tab_hover = {
        bg_color = cfg.colors.background,
        fg_color = cfg.colors.foreground,

        intensity = 'Normal', -- Half | Normal | Bold
        underline = 'None', -- None | Single | Double
        italic = true,
        strikethrough = false,
    },

    -- New tab button
    new_tab = {
        bg_color = cfg.colors.background,
        fg_color = cfg.colors.brights[1],
    },

    new_tab_hover = {
        bg_color = cfg.colors.background,
        fg_color = cfg.colors.foreground,

        intensity = 'Bold', -- Half | Normal | Bold
        italic = false,
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
