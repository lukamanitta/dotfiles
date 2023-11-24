require("gruvbox").setup({
    contrast = "hard"
})
vim.cmd("colorscheme gruvbox")
require("settings.theme").post_colorscheme_actions()
vim.cmd("hi link Function GruvboxOrangeBold")

-- For some reason cterm=reverse gui=reverse is set for these
local get_hl = require("helpers").get_hl
local statusline_bg, statusline_fg = get_hl("StatusLine", "bg#"), get_hl("StatusLine", "fg#")
local statusline_nc_bg, statusline_nc_fg = get_hl("StatusLineNC", "bg#"), get_hl("StatusLineNC", "fg#")
vim.cmd("hi! StatusLine guibg=" .. statusline_fg .. " guifg=" .. statusline_bg .. "cterm=NONE gui=NONE")
vim.cmd("hi! StatusLineNC guibg=" .. statusline_nc_fg .. " guifg=" .. statusline_nc_bg .. "cterm=NONE gui=NONE")
