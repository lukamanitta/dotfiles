local get_hl = require("helpers").get_hl
local multiply_hex_brightness = require("utils.color").multiply_hex_brightness

local U = {}

U.colorscheme = "gruvbox"

function U.pre_colorscheme_actions()
    vim.o.background = "dark"
end

function U.post_colorscheme_actions()
    vim.cmd("hi! SignColumn guibg=" .. require("helpers").get_hl("Normal", "bg#"))

    local bar_background = get_hl("StatusLine", "bg#")
    local bar_highlight_brightness_multi = ({
        dark = 1.55,
        light = -0.07,
    })[vim.o.background]

    vim.cmd(
        "hi! BarHighlight guibg="
        .. multiply_hex_brightness(bar_background, bar_highlight_brightness_multi)
    )
    vim.cmd(
        "hi! BarHighlight2 guibg="
        .. multiply_hex_brightness(bar_background, bar_highlight_brightness_multi / 1.5)
    )
end

return U
