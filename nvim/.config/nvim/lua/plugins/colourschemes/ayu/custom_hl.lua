local colours = require("ayu.colors")
colours.generate()

vim.api.nvim_set_hl(0, "rainbowcol1", {
    fg = colours.vcs_removed,
})
vim.api.nvim_set_hl(0, "rainbowcol2", {
    fg = colours.keyword,
})
vim.api.nvim_set_hl(0, "rainbowcol3", {
    fg = colours.string,
})
vim.api.nvim_set_hl(0, "rainbowcol4", {
    fg = "#6A9589",
})
vim.api.nvim_set_hl(0, "rainbowcol5", {
    fg = colours.entity,
})
vim.api.nvim_set_hl(0, "rainbowcol6", {
    fg = colours.constant,
})
vim.api.nvim_set_hl(0, "rainbowcol7", {
    fg = "#957FB8",
})
