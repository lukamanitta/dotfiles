local apply_globals = require('utils.config').apply_globals

apply_globals({
    tokyonight_style = 'storm',
    tokyonight_terminal_colors = true,
    tokyonight_italic_comments = true,
    tokyonight_italic_keywords = true,
    tokyonight_italic_functions = false,
    tokyonight_italic_variables = false,
    tokyonight_transparent = false,
    tokyonight_hide_inactive_statusline = false,
    tokyonight_sidebars = { 'NvimTree', 'Trouble' },
    tokyonight_transparent_sidebar = false,
    tokyonight_dark_sidebar = true,
    tokyonight_dark_float = true,
    tokyonight_day_brightness = 1,
    tokyonight_lualine_bold = false,
})

vim.cmd('colorscheme tokyonight')
