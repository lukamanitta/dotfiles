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

local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local blend_rgb = require("utils.color").blend_rgb

local diagnostic_types = { "Error", "Warn", "Hint", "Info" }
for _, diagnostic_type in ipairs(diagnostic_types) do
    vim.cmd(
        "hi DiagnosticVirtualText"
            .. diagnostic_type
            .. " guifg="
            .. get_hi_group_fg("DiagnosticVirtualText" .. diagnostic_type)
            .. " guibg="
            .. blend_rgb(
                get_hi_group_bg("Normal"),
                get_hi_group_fg("DiagnosticVirtualText" .. diagnostic_type),
                0.1
            )
    )
end
