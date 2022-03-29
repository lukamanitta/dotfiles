local opts = require("plugins.colourschemes.nightfox.opts")

require("nightfox").setup({
    options = opts,
})

vim.cmd("colorscheme dayfox")
