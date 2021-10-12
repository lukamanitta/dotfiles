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
    cursorline_timeout = 1000,
    -- ale_disable_lsp = 1,
    -- ale_sign_column_always = 1,
    -- ale_fix_on_save = 1,
    -- ale_fixers = {
    --     ['*'] = {'remove_trailing_lines', 'trim_whitespace'},
    --     javascript = {'prettier'},
    -- },
}
)
