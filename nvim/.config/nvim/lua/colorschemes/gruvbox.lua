require("gruvbox").setup({
    contrast = "hard"
})
vim.cmd("colorscheme gruvbox")
vim.cmd("hi link Function GruvboxOrangeBold")

-- For some reason cterm=reverse gui=reverse is set for these
local get_hl = require("helpers").get_hl
-- local statusline_bg, statusline_fg = get_hl("StatusLine", "bg#"), get_hl("StatusLine", "fg#")
-- local statusline_nc_bg, statusline_nc_fg = get_hl("StatusLineNC", "bg#"), get_hl("StatusLineNC", "fg#")
-- vim.cmd("hi! StatusLine guibg=" .. statusline_fg .. " guifg=" .. statusline_bg .. "cterm=NONE gui=NONE")
-- vim.cmd("hi! StatusLineNC guibg=" .. statusline_nc_fg .. " guifg=" .. statusline_nc_bg .. "cterm=NONE gui=NONE")

local multiply_hex_brightness = require("lib.color").multiply_hex_brightness
vim.cmd(
    "hi! StatusLine guibg="
    .. multiply_hex_brightness(get_hl("Normal", "bg#"), -0.35)
    .. " guifg="
    .. get_hl("Normal", "fg#")
    .. " gui=NONE cterm=NONE"
)

vim.cmd(
    "hi! StatusLineNC guibg="
    .. multiply_hex_brightness(get_hl("Normal", "bg#"), -0.1)
    .. " guifg="
    .. get_hl("Normal", "fg#")
    .. " gui=NONE cterm=NONE"
)

vim.cmd('hi link DiagnosticOk GruvboxGreen')

vim.cmd("hi link DiagnosticSignError DiagnosticError")
vim.cmd("hi link DiagnosticSignWarn DiagnosticWarn")
vim.cmd("hi link DiagnosticSignInfo DiagnosticInfo")
vim.cmd("hi link DiagnosticSignHint DiagnosticHint")
vim.cmd("hi link DiagnosticSignOk DiagnosticOk")