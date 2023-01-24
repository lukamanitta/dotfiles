local border_chars_none = { " ", " ", " ", " ", " ", " ", " ", " " }

local theme = ({
    flat = {
        borderchars = {
            prompt = border_chars_none,
            results = border_chars_none,
            preview = border_chars_none,
        },
        sort_mru = true,
        sorting_strategy = "ascending",
        results_title = false,
        hl_result_eol = true,
        layout_config = {
            prompt_position = "top",
        },
        border = true,
        winblend = 0,
    },
    classic = {},
})[require("settings.globals").float_style]

return theme
