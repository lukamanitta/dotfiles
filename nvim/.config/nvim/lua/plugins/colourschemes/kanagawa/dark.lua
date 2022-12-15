local cmd = vim.cmd
local opts = require("plugins.colourschemes.kanagawa.opts")

require("kanagawa").setup(vim.tbl_deep_extend("force", opts, {
    -- colors = {
    --     bg_light0 = "#16161d",
    -- },
    overrides = {},
    theme = "default",
}))

cmd("set background=dark")
cmd("colorscheme kanagawa")

require("plugins.colourschemes.kanagawa.custom_hl")

cmd("hi link NvimTreeNormalNC NvimTreeNormal")
