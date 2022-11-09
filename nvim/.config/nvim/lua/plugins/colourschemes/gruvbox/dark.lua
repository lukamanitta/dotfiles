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

vim.cmd("hi! StatusLine guibg=#3c3836 guifg=#d5c4a1 gui=none cterm=none")
