local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local get_hex = require("cokeline.utils").get_hex
local cmd = vim.cmd

cmd("set background=light")
local colors = require("ayu.colors")
colors.generate()
local statusline_color = colors.panel_border

require("ayu").setup({
    mirage = false,
})

require("ayu").colorscheme()

require("plugins.colourschemes.ayu.custom_hl")

cmd("hi! StatusLine guibg=" .. statusline_color)
cmd("hi! StatusLineNC guibg=" .. statusline_color .. " guifg=NONE")