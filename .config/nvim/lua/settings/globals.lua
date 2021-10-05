local cmd = vim.cmd
local apply_globals = require('utils.config').apply_globals

cmd 'filetype plugin indent on'

apply_globals(
{
    airline_theme = 'hybrid',
    gruvbox_contrast_dark = 'hard',
    tempus_enforce_background_colour = 1,
}
)
