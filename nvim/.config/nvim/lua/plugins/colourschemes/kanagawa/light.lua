local cmd = vim.cmd
local opts = require("plugins.colourschemes.kanagawa.opts")

require("kanagawa").setup(vim.tbl_deep_extend("force", opts, {
    overrides = {},
    theme = "light",
}))

cmd("set background=light")
cmd("colorscheme kanagawa")

cmd("hi link NvimTreeNormalNC NvimTreeNormal")
