local apply_globals = require("utils.helpers").apply_globals
local cmd = vim.cmd
local opts = require("plugins.colourschemes.tokyonight.opts")

apply_globals({
    tokyonight_style = "day", -- storm | night | day
    opts,
})

cmd("set background=light")
cmd("colorscheme tokyonight")

require("plugins.colourschemes.tokyonight.custom_hl")