local get_hi_group_bg = require("utils.config").get_hi_group_bg
local get_hex = require("cokeline.utils").get_hex
local cmd = vim.cmd

cmd("set background=dark")
local colors = require("ayu.colors")
colors.generate()
local statusline_color = colors.panel_shadow

require("ayu").setup({
    mirage = false,
    overrides = {
        panel_border = statusline_color,
    },
})

require("ayu").colorscheme()

cmd("hi! StatusLine guibg=" .. statusline_color)
cmd("hi! StatusLineNC guibg=" .. statusline_color .. " guifg=NONE")
