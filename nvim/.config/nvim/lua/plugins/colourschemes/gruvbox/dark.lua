local opts = require("plugins.colourschemes.gruvbox.opts")
local palette = require("gruvbox.palette")
local table_merge = require("utils.tables").table_merge

vim.cmd("set background=dark")

require("gruvbox").setup({
    inverse = false,
    contrast = "hard",
})

vim.cmd("colorscheme gruvbox")

require("plugins.colourschemes.gruvbox.custom_hl")

local multiply_hex_brightness = require("utils.color").multiply_hex_brightness
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
vim.cmd(
    "hi! StatusLine guibg="
    .. multiply_hex_brightness(get_hi_group_bg("Normal"), -0.35)
    .. " guifg=#d5c4a1 gui=none cterm=none"
)
