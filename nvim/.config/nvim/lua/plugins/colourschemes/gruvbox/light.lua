local opts = require("plugins.colourschemes.gruvbox.opts")

vim.cmd("set background=light")

require("gruvbox").setup({
    inverse = false,
    contrast = "hard",
})

vim.cmd("colorscheme gruvbox")

require("plugins.colourschemes.gruvbox.custom_hl")

vim.cmd("hi! StatusLine guibg=#ebdbb2 guifg=#504945 gui=none cterm=none")
