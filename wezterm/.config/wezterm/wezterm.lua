local wezterm = require("wezterm")

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
    
    -- Keybinds
    leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
    send_composed_key_when_left_alt_is_pressed = true,
    send_composed_key_when_right_alt_is_pressed = false,
    keys = require("keybinds"),

    -- Colors
    color_scheme = "Kanagawa",

    -- Fonts
    font_dirs = {
        "~/dotfiles/fonts",
        "~/dotfiles/fonts/RobotoMono",
        "~/dotfiles/fonts/Cousine",
        "~/dotfiles/fonts/SourceCodePro", -- SourceCodePro Nerd Font
        "~/dotfiles/fonts/Hasklug",       -- Hasklug Nerd Font Mono
        "~/dotfiles/fonts/JetBrainsMono", -- JetBrainsMono Nerd Font
        "~/dotfiles/fonts/OperatorMono",  -- OperatorMono Nerd Font
        "~/dotfiles/fonts/Liga SFMono",   -- SFMono Nerd Font
        "~/dotfiles/fonts/Terminess",     -- Terminess (Terminus) Nerd Font
    },
    -- font = wezterm.font("OperatorMono Nerd Font", { weight = "Book" }),
    font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" }),
    font_size = 12.5,
    line_height = 1.1,
    underline_thickness = 2,
    underline_position = -5.0,
    harfbuzz_features = { "clig=1" },
    bold_brightens_ansi_colors = true,
    font_rules = require("font_rules")
}

-- Can't really refactor this nicely because using any kind of table.insert
-- or table[k] = v turns the table into an Array? Wezterm can't convert this
-- to a config object

return cfg
