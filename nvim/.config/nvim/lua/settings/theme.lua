local get_hl = require("helpers").get_hl
local multiply_hex_brightness = require("lib.color").multiply_hex_brightness
local blend_hex = require("lib.color").blend_hex

local U = {}

-- gruvbox | kanagawa | catppuccin
U.colorscheme = "catppuccin"

function U.pre_colorscheme_actions()
    vim.o.background = "dark"
end

function U.post_colorscheme_actions()
    vim.cmd(
        "hi! SignColumn guibg=" .. require("helpers").get_hl("Normal", "bg#")
    )

    local bar_background = get_hl("StatusLine", "bg#")
    local bar_highlight_brightness_multi = ({
        dark = 1.55,
        light = -0.1,
    })[vim.o.background]

    vim.cmd(
        "hi! BarHighlight guibg="
        .. multiply_hex_brightness(
            bar_background,
            bar_highlight_brightness_multi
        )
    )
    vim.cmd(
        "hi! BarHighlight2 guibg="
        .. multiply_hex_brightness(
            bar_background,
            bar_highlight_brightness_multi / 1.5
        )
    )

    vim.cmd("hi! Pmenu guibg=" .. get_hl("BarHighlight2", "bg#"))

    vim.cmd(
        "hi! String guifg=" .. get_hl("String", "fg#") .. " gui=NONE cterm=NONE"
    )

    local diagnostic_levels = { "Error", "Warn", "Hint", "Info" }
    for _, diagnostic_level in ipairs(diagnostic_levels) do
        local hl_name = "DiagnosticVirtualText" .. diagnostic_level
        vim.cmd(
            "hi! "
            .. hl_name
            .. " guifg="
            .. get_hl(hl_name, "fg#")
            .. " guibg="
            .. blend_hex(
                get_hl("Normal", "bg#"),
                get_hl(hl_name, "fg#"),
                0.09
            )
        )
    end
end

return U
