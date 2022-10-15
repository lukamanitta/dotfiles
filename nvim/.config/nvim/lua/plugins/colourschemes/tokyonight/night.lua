local apply_globals = require("utils.helpers").apply_globals
local cmd = vim.cmd

apply_globals({
    tokyonight_style = "night", -- storm | night | day
    tokyonight_terminal_colors = true,
    tokyonight_italic_comments = true,
    tokyonight_italic_keywords = true,
    tokyonight_italic_functions = false,
    tokyonight_italic_variables = false,
    tokyonight_transparent = false,
    tokyonight_hide_inactive_statusline = false,
    tokyonight_sidebars = { "NvimTree", "Trouble" },
    tokyonight_transparent_sidebar = false,
    tokyonight_dark_sidebar = true,
    tokyonight_dark_float = true,
    tokyonight_day_brightness = 1,
    tokyonight_lualine_bold = false,
})

cmd("set background=dark")
cmd("colorscheme tokyonight")
