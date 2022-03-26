local cmd = vim.cmd
local apply_globals = require('utils.config').apply_globals

local vars = {}

-- Available colorschemes: 'tokyonight_{night, day, storm}, 'ayu_{light, dark, mirage}', 'kanagawa'
vars.colourscheme = 'kanagawa'

cmd('filetype plugin indent on')

apply_globals({
    matchup_matchparen_offscreen = { method = 'popup' },
    cursorline_timeout = 500,
    scrolloff = 10,
    sidescrolloff = 5,
    markdown_fenced_languages = { 'html', 'python', 'bash=sh', 'dafny' },
})

return vars
