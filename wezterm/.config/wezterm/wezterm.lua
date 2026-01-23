local wezterm = require("wezterm")
local home = os.getenv("HOME")
local helpers = require("helpers")

-- TODO: get this working
-- wezterm.font = function(name, opts)
--     wezterm.font_with_fallback(
--         helpers.combine_tables({ family = name }, opts),
--         "Symbols Nerd Font"
--     )
-- end

local cfg = {
    set_environment_variables = {
        COLORTERM = "truecolor",
    },
    --General--
    warn_about_missing_glyphs = true,
    window_background_opacity = helpers.is_linux() and 0.98 or 0.98,
    native_macos_fullscreen_mode = true,
    debug_key_events = false,

    initial_cols = 90,
    initial_rows = 28,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },

    tab_bar_at_bottom = true,
    use_fancy_tab_bar = false,
    tab_max_width = 15,

    enable_kitty_graphics = true,
    enable_wayland = false,
    default_cursor_style = "BlinkingBlock",
    force_reverse_video_cursor = true,

    -- Keybinds
    leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
    send_composed_key_when_left_alt_is_pressed = true,
    send_composed_key_when_right_alt_is_pressed = false,
    keys = require("keybinds"),

    -- Colors
    -- color_scheme = "Luka",
    color_scheme = "zenwritten-dark",

    -- Fonts
    -- font_locator = "ConfigDirsOnly",
    font_dirs = {
        home .. "/.fonts",
    },
    -- font = wezterm.font("JetBrains Mono", { weight = "Medium" }),
    -- font_rules = require("font_rules").jetbrains,

    -- font = wezterm.font("Fira Code", { weight = "Medium" }),
    -- font_rules = require("font_rules").firacode,

    font = wezterm.font("Roboto Mono", { weight = "Medium" }),

    -- font = wezterm.font("CommitMono", { weight = "Regular" }),
    -- font_rules = require("font_rules").commitmono,

    -- font = wezterm.font("IBM Plex Mono", { weight = "Medium" }),
    -- font_rules = require("font_rules").ibmplexmono,

    -- font = wezterm.font("DinaRemasterII", { weight = "Medium" }),

    font_size = helpers.is_linux() and 11.25 or 12.0,
    line_height = 1.3,

    underline_thickness = 2,
    underline_position = -5.0,

    harfbuzz_features = { "clig=1" },
    bold_brightens_ansi_colors = true,
}

-- Can't really refactor this nicely because using any kind of table.insert
-- or table[k] = v turns the table into an Array? Wezterm can't convert this
-- to a config object
wezterm.add_to_config_reload_watch_list(
    home .. "/.config/wezterm/colors/Luka.toml"
)

return cfg
