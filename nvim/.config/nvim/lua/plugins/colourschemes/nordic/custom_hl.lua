local nord_palette = require("nordic.colors")

vim.api.nvim_set_hl(0, "rainbowcol1", {
    fg = nord_palette.red.base,
})
vim.api.nvim_set_hl(0, "rainbowcol2", {
    fg = nord_palette.orange.base,
})
vim.api.nvim_set_hl(0, "rainbowcol3", {
    fg = nord_palette.green.base,
})
vim.api.nvim_set_hl(0, "rainbowcol4", {
    fg = nord_palette.cyan.base,
})
vim.api.nvim_set_hl(0, "rainbowcol5", {
    fg = nord_palette.blue.base,
})
vim.api.nvim_set_hl(0, "rainbowcol6", {
    fg = nord_palette.magenta.bright,
})
vim.api.nvim_set_hl(0, "rainbowcol7", {
    fg = nord_palette.magenta.base,
})
