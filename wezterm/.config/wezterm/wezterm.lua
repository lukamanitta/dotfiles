local wezterm = require("wezterm")
local osPathSep = package.config:sub(1, 1)
local onWindows = osPathSep == "\\"
local cfg = {
    --General--

    warn_about_missing_glyphs = true,
    window_background_opacity = 1,
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
        "~/dotfiles/fonts/SourceCodePro", -- SourceCodePro Nerd Font
        "~/dotfiles/fonts/Hasklug", -- Hasklug Nerd Font Mono
        "~/dotfiles/fonts/JetBrainsMono", -- JetBrainsMono Nerd Font
        "~/dotfiles/fonts/OperatorMono", -- OperatorMono Nerd Font
    },

    -- font = wezterm.font("OperatorMono Nerd Font", { weight = "Book" }),
    font = wezterm.font("JetBrainsMono Nerd Font"),
    font_size = 13,
    line_height = 1.25,
    harfbuzz_features = { "clig=1" },
    bold_brightens_ansi_colors = true,
    font_rules = {
        {
            intensity = "Bold",
            font = wezterm.font(
                "JetBrainsMono Nerd Font",
                { weight = "ExtraBold" }
            ),
        },
        {
            intensity = "Bold",
            italic = true,
            font = wezterm.font(
                "JetBrainsMono Nerd Font",
                { weight = "ExtraBold" }
            ),
        },
        {
            intensity = "Half",
            font = wezterm.font(
                "JetBrainsMono Nerd Font",
                { weight = "Light" }
            ),
        },
        -- {
        --     intensity = "Half",
        --     italic = true,
        --     font = wezterm.font(
        --         "JetBrainsMono Light Italic Nerd Font",
        --         { weight = "Light Italic" }
        --     ),
        -- },
    },

    --Keybindings--

    leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },

    send_composed_key_when_left_alt_is_pressed = true,
    send_composed_key_when_right_alt_is_pressed = false,

    keys = {
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
            "#090618", -- Black
            "#c34043", -- Red
            "#76946a", -- Green
            "#c0a36e", -- Yellow
            "#7e9cd8", -- Blue
            "#957fb8", -- Magenta
            "#6a9589", -- Cyan
            "#c8c093", -- White
        },
        brights = {
            "#727169", -- Black
            "#e82424", -- Red
            "#98bb6c", -- Green
            "#e6c384", -- Yellow
            "#7fb4ca", -- Blue
            "#938aa9", -- Magenta
            "#7aa89f", -- Cyan
            "#dcd7ba", -- White
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
            "#393b44", -- Black
            "#c94f6d", -- Red
            "#81b29a", -- Green
            "#dbc074", -- Yellow
            "#719cd6", -- Blue
            "#9d79d6", -- Magenta
            "#63cdcf", -- Cyan
            "#dfdfe0", -- White
        },
        brights = {
            "#575860", -- Black
            "#d16983", -- Red
            "#8ebaa4", -- Green
            "#e0c989", -- Yellow
            "#86abdc", -- Blue
            "#baa1e2", -- Magenta
            "#7ad4d6", -- Cyan
            "#e4e4e5", -- White
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
            "#575279", -- Black
            "#b4637a", -- Red
            "#618774", -- Green
            "#ea9d34", -- Yellow
            "#286983", -- Blue
            "#907aa9", -- Magenta
            "#56949f", -- Cyan
            "#e5e9f0", -- White
        },
        brights = {
            "#5f5695", -- Black
            "#c26d85", -- Red
            "#629f81", -- Green
            "#eea846", -- Yellow
            "#2d81a3", -- Blue
            "#9a80b9", -- Magenta
            "#5ca7b4", -- Cyan
            "#e6ebf3", -- White
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
            "#1d344f", -- Black
            "#b95d76", -- Red
            "#618774", -- Green
            "#ba793e", -- Yellow
            "#4d688e", -- Blue
            "#8e6f98", -- Magenta
            "#6ca7bd", -- Cyan
            "#cdd1d5", -- White
        },
        brights = {
            "#24476f", -- Black
            "#c76882", -- Red
            "#629f81", -- Green
            "#ca884a", -- Yellow
            "#4e75aa", -- Blue
            "#9f75ac", -- Magenta
            "#74b2c9", -- Cyan
            "#cfd6dd", -- White
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
            "#393552", -- Black
            "#eb6f92", -- Red
            "#a3be8c", -- Green
            "#f6c177", -- Yellow
            "#569fba", -- Blue
            "#c4a7e7", -- Magenta
            "#9ccfd8", -- Cyan
            "#e0def4", -- White
        },
        brights = {
            "#47407d", -- Black
            "#f083a2", -- Red
            "#b1d196", -- Green
            "#f9cb8c", -- Yellow
            "#65b1cd", -- Blue
            "#ccb1ed", -- Magenta
            "#a6dae3", -- Cyan
            "#e2e0f7", -- White
        },
    },

    noctis = {
        foreground = "#66ffbf",
        background = "#141414",

        cursor_bg = "#f2f4f8",
        cursor_fg = "#161616",
        cursor_border = "#f2f4f8",

        selection_fg = "#66ffbf",
        selection_bg = "#2a2a2a",

        scrollbar_thumb = "#2a2a2a",
        split = "#2a2a2a",

        ansi = {
            "#0c0c0c", -- Black
            "#ee5396", -- Red
            "#25be6a", -- Green
            "#cbcb41", -- Yellow
            "#33b1ff", -- Blue
            "#ff91c1", -- Magenta
            "#3ddbd9", -- Cyan
            "#f2f4f8", -- White
        },
        brights = {
            "#727169", -- Black
            "#ee5396", -- Red
            "#25be6a", -- Green
            "#cbcb41", -- Yellow
            "#8cb6ff", -- Blue
            "#ee5396", -- Magenta
            "#5ae0df", -- Cyan
            "#7b7c7e", -- White
        },
    },

    gruvbox_dark_hard = {
        foreground = "#f9f5d7",
        background = "#1d2021",

        cursor_bg = "#f9f5d7",
        cursor_fg = "#1d2021",
        cursor_border = "#1d2021",

        selection_fg = "#f9f5d7",
        selection_bg = "#665c54",

        scrollbar_thumb = "#665c54",
        split = "#665c54",

        ansi = {
            "#1d2021", -- Black
            "#cc241d", -- Red
            "#98971a", -- Green
            "#d79921", -- Yellow
            "#458588", -- Blue
            "#b16286", -- Magenta
            "#689d6a", -- Cyan
            "#f9f5d7", -- White
        },
        brights = {
            "#7c6f64", -- Black
            "#fb4934", -- Red
            "#b8bb26", -- Green
            "#fabd2f", -- Yellow
            "#83a598", -- Blue
            "#d3869b", -- Magenta
            "#8ec07c", -- Cyan
            "#ebdbb2", -- White
        },
    },
}

-- local colourscheme = os.getenv('COLOURSCHEME')
-- tokyonight_{night, day, storm}, ayu_{light, dark, mirage}, kanagawa, nightfox_{night, dawn, day, dusk}, gruvbox_{light, dark}_{soft, hard}
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
        italic = true,
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
