local cmd = vim.cmd
local apply_globals = require('utils.config').apply_globals

cmd 'filetype plugin indent on'
cmd 'colorscheme catppuccino'
cmd 'set background=dark'

apply_globals(
{
    gruvbox_contrast_dark = 'hard',
    tempus_enforce_background_colour = 1,
    matchup_matchparen_offscreen = { method = 'popup'},
}
)
