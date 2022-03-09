local apply_globals = require('utils.config').apply_globals
local invert_hex_color = require('utils.color').invert_hex_color

apply_globals({
    cursorword_disable_filetypes = { 'Trouble' },
    cursorword_min_width = 2,
    cursorword_max_width = 50,
})

vim.cmd('hi! CursorWord guibg=#414868 guifg=' .. invert_hex_color('#414868'))
-- vim.cmd('hi! link CursorWord Visual')
