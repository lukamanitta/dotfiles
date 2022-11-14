local palette = require("gruvbox.palette")
local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local change_hex_brightness = require("utils.color").change_hex_brightness
local blend_rgb = require("utils.color").blend_rgb

vim.api.nvim_set_hl(0, "IncSearch", {
    fg = get_hi_group_fg("IncSearch"),
    bg = get_hi_group_bg("Visual"),
})

vim.api.nvim_set_hl(0, "Search", {
    fg = get_hi_group_fg("Search"),
    bg = get_hi_group_bg("Visual"),
})

-- red, aqua, blue, green, purple, orange, yellow
-- Change Gruvbox[Color]Sign background to normal for each colour
local sign_colours = {
    "Red",
    "Aqua",
    "Blue",
    "Green",
    "Purple",
    "Orange",
    "Yellow",
}
for _, colour in ipairs(sign_colours) do
    vim.cmd(
        "highlight! Gruvbox"
        .. colour
        .. "Sign  guibg="
        .. get_hi_group_bg("Normal")
        .. " guifg="
        .. get_hi_group_fg("Gruvbox" .. colour .. "Sign")
    )
end
vim.cmd("hi! SignColumn guibg=" .. get_hi_group_bg("Normal"))

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

vim.api.nvim_set_hl(0, "rainbowcol1", {
    fg = palette.bright_red,
})
vim.api.nvim_set_hl(0, "rainbowcol2", {
    fg = palette.neutral_orange,
})
vim.api.nvim_set_hl(0, "rainbowcol3", {
    fg = palette.neutral_green,
})
vim.api.nvim_set_hl(0, "rainbowcol4", {
    fg = palette.neutral_aqua,
})
vim.api.nvim_set_hl(0, "rainbowcol5", {
    fg = palette.neutral_blue,
})
vim.api.nvim_set_hl(0, "rainbowcol6", {
    fg = palette.bright_purple,
})
vim.api.nvim_set_hl(0, "rainbowcol7", {
    fg = palette.neutral_purple,
})

local random_range = require("utils.math").random_range

vim.cmd(
    "hi FloatBorder guibg="
    .. get_hi_group_bg("Normal")
    .. " guifg="
    .. get_hi_group_fg("rainbowcol" .. random_range(1, 7, os.time()))
)
vim.cmd("hi NormalFloat guibg=" .. get_hi_group_bg("Normal"))
-- vim.cmd("hi FloatTitle guibg=" .. get_hi_group_bg("Normal"))
