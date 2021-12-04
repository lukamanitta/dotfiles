local cmd = vim.cmd
local apply_globals = require('utils.config').apply_globals

cmd('colorscheme catppuccin')
cmd('filetype plugin indent on')
cmd('set background=dark')

apply_globals({
    matchup_matchparen_offscreen = { method = 'popup' },
    cursorline_timeout = 500,
    scrolloff = 10,
    sidescrolloff = 5,
})
