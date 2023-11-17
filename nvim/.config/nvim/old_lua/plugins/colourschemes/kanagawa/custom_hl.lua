local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg

vim.cmd("hi! SignColumn guibg=" .. get_hi_group_bg("Normal"))
vim.cmd("hi! SignColumnSB guibg=" .. get_hi_group_bg("Normal"))
vim.cmd("hi! LineNr guibg=" .. get_hi_group_bg("Normal"))
vim.cmd("hi! LineNrAbove guibg=" .. get_hi_group_bg("Normal"))
vim.cmd("hi! LineNrBelow guibg=" .. get_hi_group_bg("Normal"))
vim.cmd("hi! CursorLineFold guibg=" .. get_hi_group_bg("Normal"))
vim.cmd("hi! CursorLineNr guibg=" .. get_hi_group_bg("Normal"))

vim.api.nvim_set_hl(0, "rainbowcol1", {
    fg = "#C34043",
})
vim.api.nvim_set_hl(0, "rainbowcol2", {
    fg = "#FF9E3B",
})
vim.api.nvim_set_hl(0, "rainbowcol3", {
    fg = "#98BB6C",
})
vim.api.nvim_set_hl(0, "rainbowcol4", {
    fg = "#6A9589",
})
vim.api.nvim_set_hl(0, "rainbowcol5", {
    fg = "#7E9CD8",
})
vim.api.nvim_set_hl(0, "rainbowcol6", {
    fg = "#D27E99",
})
vim.api.nvim_set_hl(0, "rainbowcol7", {
    fg = "#957FB8",
})

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
