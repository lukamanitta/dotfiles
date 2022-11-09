local opts = require("plugins.colourschemes.gruvbox.opts")

require("gruvbox").setup(vim.tbl_deep_extend("force", opts, {
    contrast = "soft",
}))

vim.cmd("set background=light")
vim.cmd("colorscheme gruvbox")
