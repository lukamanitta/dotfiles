local opts = require("plugins.colourschemes.gruvbox.opts")

require("gruvbox").setup(vim.tbl_deep_extend("force", opts, {
    contrast = "hard",
}))

vim.cmd("hi! link SignColumn Normal")
vim.cmd("set background=dark")
vim.cmd("colorscheme gruvbox")
