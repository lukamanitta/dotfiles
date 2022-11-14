local cmd = vim.cmd
local apply_globals = require("utils.helpers").apply_globals

local vars = {}

-- vars.colourscheme = os.getenv('COLOURSCHEME')
-- tokyonight_{night, day, storm}, ayu_{light, dark, mirage}, kanagawa_{dark, light}, nightfox_{night, dawn, day, dusk}, noctis, gruvbox_{light, dark}
vars.colourscheme = "gruvbox_dark"
vars.lsp_icon_style = "solid" -- "solid", "outline", "none"

cmd("filetype plugin indent on")

apply_globals({
    matchup_matchparen_offscreen = { method = "popup" },
    cursorline_timeout = 500,
    scrolloff = 10,
    sidescrolloff = 5,
    markdown_fenced_languages = { "html", "python", "bash=sh", "dafny" },
    omni_sql_default_compl_type = "syntax",
})

return vars
