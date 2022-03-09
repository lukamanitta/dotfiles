local apply_globals = require('utils.config').apply_globals

apply_globals({
    cursorword_disable_filetypes = { 'Trouble' },
    cursorword_min_width = 2,
    cursorword_max_width = 50,
})

vim.cmd('hi! link CursorWord Visual')
