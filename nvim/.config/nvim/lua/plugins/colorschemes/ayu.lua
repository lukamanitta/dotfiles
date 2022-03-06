local get_hi_group_bg = require('utils.config').get_hi_group_bg
local get_hex = require('cokeline.utils').get_hex

require('ayu').setup({
    mirage = true,
    overrides = {},
})

require('ayu').colorscheme()

vim.cmd('hi! link StatusLine lualine_c_normal')
vim.cmd('hi! StatusLineNC guibg=#101521')
-- Fix StatusLineNC not matching StatusLine

vim.cmd('hi! CursorWord gui=NONE')
