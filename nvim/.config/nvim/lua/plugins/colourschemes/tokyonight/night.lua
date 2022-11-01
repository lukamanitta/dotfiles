local apply_globals = require("utils.helpers").apply_globals
local cmd = vim.cmd
local opts = require("plugins.colourschemes.tokyonight.opts")

apply_globals({
    tokyonight_style = "night", -- storm | night | day
    opts,
})

cmd("set background=dark")
cmd("colorscheme tokyonight")
