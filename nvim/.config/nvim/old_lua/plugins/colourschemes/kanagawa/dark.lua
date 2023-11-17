local cmd = vim.cmd
local opts = require("plugins.colourschemes.kanagawa.opts")
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg

require("kanagawa").setup(vim.tbl_deep_extend("force", opts, {
    colors = {
        theme = {
            all = {
                ui = {
                    bg_gutter = "none",
                },
            },
        },
    },
}))

cmd("set background=dark")
cmd("colorscheme kanagawa")

require("plugins.colourschemes.kanagawa.custom_hl")
