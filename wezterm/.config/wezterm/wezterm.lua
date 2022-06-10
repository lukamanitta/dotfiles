local wezterm = require("wezterm")
local osPathSep = package.config:sub(1, 1)
local onWindows = osPathSep == "\\"
local cfg = {
    --General--

    warn_about_missing_glyphs = true,
    window_background_opacity = 1.0,
    native_macos_fullscreen_mode = true,
    initial_cols = 90,
    initial_rows = 28,

    tab_bar_at_bottom = true,
    use_fancy_tab_bar = false,
    tab_max_width = 15,
    enable_kitty_graphics = true,

    default_cursor_style = "BlinkingBlock",
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    force_reverse_video_cursor = true,

    --Fonts--

    font_dirs = {
        "~/dotfiles/fonts",
        "~/dotfiles/fonts/RobotoMono",
        "~/dotfiles/fonts/Cousine",
        "~/dotfiles/fonts/SourceCodePro",
        "~/dotfiles/fonts/Hasklug",
    },

    font = wezterm.font("APL386 Nerd Font"),
    font_size = 15,

    --Keybindings--

    leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },

    send_composed_key_when_left_alt_is_pressed = true,
    send_composed_key_when_right_alt_is_pressed = false,

    keys = {
        --- Keybindings for Multiplex
        {
            key = "/",
            mods = "LEADER",
            action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
        },
        {
            key = "-",
            mods = "LEADER",
            action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
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
    },
}

if onWindows then
    cfg.default_prog = { "wsl", "~" } --Start linux subsystem and go to linux home dir
end

-- Tab switching keys (saves repeating essentially the same keybinding 10 times)
for tabNum = 1, 9 do
    table.insert(cfg.keys, {
        key = tostring(tabNum),
        mods = "LEADER",
        action = wezterm.action({ ActivateTab = tabNum - 1 }),
    })
end

local colours = {
    kanagawa = {
        foreground = "#dcd7ba",
        background = "#1f1f28",

        cursor_bg = "#c8c093",
        cursor_fg = "#c8c093",
        cursor_border = "#c8c093",

        selection_fg = "#c8c093",
        selection_bg = "#2d4f67",

        scrollbar_thumb = "#16161d",
        split = "#16161d",

        ansi = {
            "#090618",
            "#c34043",
            "#76946a",
            "#c0a36e",
            "#7e9cd8",
            "#957fb8",
            "#6a9589",
            "#c8c093",
        },
        brights = {
            "#727169",
            "#e82424",
            "#98bb6c",
            "#e6c384",
            "#7fb4ca",
            "#938aa9",
            "#7aa89f",
            "#dcd7ba",
        },
    },

    tokyonight_night = {
        foreground = "#c0caf5",
        background = "#1a1b26",

        cursor_bg = "#c0caf5",
        cursor_fg = "#1a1b26",
        cursor_border = "#c0caf5",

        selection_fg = "#c0caf5",
        selection_bg = "#33467c",

        scrollbar_thumb = "#c0caf5",

        split = "#2a2e36",

        ansi = {
            "#15161E", -- Black
            "#f7768e", -- Red
            "#9ece6a", -- Green
            "#e0af68", -- Yellow
            "#7aa2f7", -- Blue
            "#bb9af7", -- Magenta
            "#7dcfff", -- Cyan
            "#a9b1d6", -- White
        },
        brights = {
            "#414868", -- Black
            "#f7768e", -- Red
            "#9ece6a", -- Green
            "#e0af68", -- Yellow
            "#7aa2f7", -- Blue
            "#bb9af7", -- Magenta
            "#7dcfff", -- Cyan
            "#c0caf5", -- White
        },
    },

    tokyonight_day = {
        foreground = "#3760bf",
        background = "#e1e2e7",

        cursor_bg = "#3760bf",
        cursor_fg = "#e1e2e7",
        cursor_border = "#3760bf",

        selection_bg = "#99a7df",
        selection_fg = "#3760bf",

        ansi = {
            "#e9e9ed", -- Black
            "#f52a65", -- Red
            "#587539", -- Green
            "#8c6c3e", -- Yellow
            "#2e7de9", -- Blue
            "#9854f1", -- Magenta
            "#007197", -- Cyan
            "#6172b0", -- White
        },
        brights = {
            "#a1a6c5", -- Black
            "#f52a65", -- Red
            "#587539", -- Green
            "#8c6c3e", -- Yellow
            "#2e7de9", -- Blue
            "#9854f1", -- Magenta
            "#007197", -- Cyan
            "#3760bf", -- White
        },
    },

    tokyonight_storm = {
        foreground = "#c0caf5",
        background = "#24283b",

        cursor_bg = "#c0caf5",
        cursor_fg = "#24283b",
        cursor_border = "#c0caf5",

        selection_bg = "#364A82",
        selection_fg = "#c0caf5",

        ansi = {
            "#1D202F", -- Black
            "#f7768e", -- Red
            "#9ece6a", -- Green
            "#e0af68", -- Yellow
            "#7aa2f7", -- Blue
            "#bb9af7", -- Magenta
            "#7dcfff", -- Cyan
            "#a9b1d6", -- White
        },
        brights = {
            "#414868", -- Black
            "#f7768e", -- Red
            "#9ece6a", -- Green
            "#e0af68", -- Yellow
            "#7aa2f7", -- Blue
            "#bb9af7", -- Magenta
            "#7dcfff", -- Cyan
            "#c0caf5", -- White
        },
    },

    ayu_dark = {
        foreground = "#b3b1ad",
        background = "#0a0e14",

        cursor_bg = "#b3b1ad",
        cursor_fg = "#0a0e14",
        cursor_border = "#b3b1ad",

        selection_bg = "#273747",
        selection_fg = "#b3b1ad",

        ansi = {
            "#0a0e14", -- Black
            "#f07178", -- Red
            "#c2d94c", -- Green
            "#e6b450", -- Yellow
            "#39bae6", -- Blue
            "#ffee99", -- Magenta
            "#95e6cb", -- Cyan
            "#b3b1ad", -- White
        },
        brights = {
            "#3e4b59", -- Black
            "#ff3333", -- Red
            "#c2d94c", -- Green
            "#e6b450", -- Yellow
            "#39bae6", -- Blue
            "#ffee99", -- Magenta
            "#95e6cb", -- Cyan
            "#626a73", -- White
        },
    },

    ayu_mirage = {
        foreground = "#cbccc6",
        background = "#1f2430",

        cursor_bg = "#cbccc6",
        cursor_fg = "#1f2430",
        cursor_border = "#cbccc6",

        selection_bg = "#33415e",
        selection_fg = "#cbccc6",

        ansi = {
            "#1f2430", -- Black
            "#f28779", -- Red
            "#bae67e", -- Green
            "#ffcc66", -- Yellow
            "#5ccfe6", -- Blue
            "#d4bfff", -- Magenta
            "#95e6cb", -- Cyan
            "#cbccc6", -- White
        },
        brights = {
            "#607080", -- Black
            "#ff3333", -- Red
            "#bae67e", -- Green
            "#ffcc66", -- Yellow
            "#5ccfe6", -- Blue
            "#d4bfff", -- Magenta
            "#95e6cb", -- Cyan
            "#5c6773", -- White
        },
    },

    ayu_light = {
        foreground = "#575f66",
        background = "#fafafa",

        cursor_bg = "#575f66",
        cursor_fg = "#fafafa",
        cursor_border = "#575f66",

        selection_bg = "#d1e4f4",
        selection_fg = "#575f66",

        ansi = {
            "#fafafa", -- Black
            "#f07171", -- Red
            "#86b300", -- Green
            "#ff9940", -- Yellow
            "#55b4d4", -- Blue
            "#a37acc", -- Magenta
            "#4cbf99", -- Cyan
            "#575f66", -- White
        },
        brights = {
            "#828c99", -- Black
            "#f51818", -- Red
            "#86b300", -- Green
            "#ff9940", -- Yellow
            "#55b4d4", -- Blue
            "#a37acc", -- Magenta
            "#4cbf99", -- Cyan
            "#abb0b6", -- White
        },
    },

    nightfox_night = {
        foreground = "#cdcecf",
        background = "#192330",

        cursor_bg = "#cdcecf",
        cursor_border = "#cdcecf",
        cursor_fg = "#192330",

        selection_bg = "#223249",
        selection_fg = "#cdcecf",

        ansi = {
            "#393b44",
            "#c94f6d",
            "#81b29a",
            "#dbc074",
            "#719cd6",
            "#9d79d6",
            "#63cdcf",
            "#dfdfe0",
        },
        brights = {
            "#575860",
            "#d16983",
            "#8ebaa4",
            "#e0c989",
            "#86abdc",
            "#baa1e2",
            "#7ad4d6",
            "#e4e4e5",
        },
    },

    nightfox_dawn = {
        foreground = "#575279",
        background = "#faf4ed",
        cursor_bg = "#575279",
        cursor_border = "#575279",
        cursor_fg = "#faf4ed",
        selection_bg = "#d0d8d8",
        selection_fg = "#575279",
        ansi = {
            "#575279",
            "#b4637a",
            "#618774",
            "#ea9d34",
            "#286983",
            "#907aa9",
            "#56949f",
            "#e5e9f0",
        },
        brights = {
            "#5f5695",
            "#c26d85",
            "#629f81",
            "#eea846",
            "#2d81a3",
            "#9a80b9",
            "#5ca7b4",
            "#e6ebf3",
        },
    },

    nightfox_day = {
        foreground = "#1d344f",
        background = "#eaeaea",
        cursor_bg = "#1d344f",
        cursor_border = "#1d344f",
        cursor_fg = "#eaeaea",
        selection_bg = "#ced5de",
        selection_fg = "#1d344f",
        ansi = {
            "#1d344f",
            "#b95d76",
            "#618774",
            "#ba793e",
            "#4d688e",
            "#8e6f98",
            "#6ca7bd",
            "#cdd1d5",
        },
        brights = {
            "#24476f",
            "#c76882",
            "#629f81",
            "#ca884a",
            "#4e75aa",
            "#9f75ac",
            "#74b2c9",
            "#cfd6dd",
        },
    },

    nightfox_dusk = {
        foreground = "#e0def4",
        background = "#232136",
        cursor_bg = "#e0def4",
        cursor_border = "#e0def4",
        cursor_fg = "#232136",
        selection_bg = "#433c59",
        selection_fg = "#e0def4",
        ansi = {
            "#393552",
            "#eb6f92",
            "#a3be8c",
            "#f6c177",
            "#569fba",
            "#c4a7e7",
            "#9ccfd8",
            "#e0def4",
        },
        brights = {
            "#47407d",
            "#f083a2",
            "#b1d196",
            "#f9cb8c",
            "#65b1cd",
            "#ccb1ed",
            "#a6dae3",
            "#e2e0f7",
        },
    },
}

-- local colourscheme = os.getenv('COLOURSCHEME')
-- tokyonight_{night, day, storm}, ayu_{light, dark, mirage}, kanagawa, nightfox_{night, dawn, day, dusk}
local colourscheme = "kanagawa"

cfg.colors = colours[colourscheme]

cfg.colors.tab_bar = {
    background = cfg.colors.background,

    active_tab = {
        bg_color = cfg.colors.background,
        fg_color = cfg.colors.foreground,

        intensity = "Bold", -- Half | Normal | Bold
        underline = "None", -- None | Single | Double
        italic = false,
        strikethrough = false,
    },

    inactive_tab = {
        bg_color = cfg.colors.background,
        fg_color = cfg.colors.brights[1],

        intensity = "Normal", -- Half | Normal | Bold
        underline = "None", -- None | Single | Double
        italic = false,
        strikethrough = false,
    },

    inactive_tab_hover = {
        bg_color = cfg.colors.background,
        fg_color = cfg.colors.foreground,

        intensity = "Normal", -- Half | Normal | Bold
        underline = "None", -- None | Single | Double
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

        intensity = "Bold", -- Half | Normal | Bold
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
