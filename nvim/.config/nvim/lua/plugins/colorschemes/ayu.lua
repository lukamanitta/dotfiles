local get_hi_group_bg = require('utils.config').get_hi_group_bg
local get_hex = require('cokeline.utils').get_hex
local cmd = vim.cmd

local statusline_color = '#101521'

require('ayu').setup({
    mirage = true,
    overrides = {
        panel_border = statusline_color,
    },
})

cmd('set background=dark')
require('ayu').colorscheme()

cmd('hi! StatusLine guibg=' .. statusline_color)
cmd('hi! StatusLineNC guibg=' .. statusline_color .. ' guifg=NONE')

cmd('hi! CursorWord gui=NONE')
