local get_hi_group_bg = require('utils.config').get_hi_group_bg

require('ayu').setup({
    mirage = true,
    overrides = {},
})

require('ayu').colorscheme()

vim.cmd('hi! link StatusLine lualine_c_normal')
-- Fix StatusLineNC not matching StatusLine
