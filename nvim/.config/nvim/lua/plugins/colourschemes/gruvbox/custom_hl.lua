local palette = require("gruvbox.palette")
local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg

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
