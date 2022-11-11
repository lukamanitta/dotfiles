local random_range = require("utils.math").random_range
local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local Set = require("utils.collections.Set")

vim.cmd("hi! link TelescopeBorder FloatBorder")
vim.cmd("hi! link TelescopeTitle FloatBorder")

local pane_types = {
    "TelescopePrompt",
    "TelescopeResults",
    "TelescopePreview",
}

local available_colours = Set:new({ 1, 2, 3, 4, 5, 6, 7 })

for _, pane in ipairs(pane_types) do
    local random_num = random_range(1, available_colours:size())
    local colour = available_colours:at(random_num)
    vim.cmd(
        "hi "
        .. pane
        .. "Border"
        .. " guibg="
        .. get_hi_group_bg("TelescopeBorder")
        .. " guifg="
        .. get_hi_group_fg("rainbowcol" .. colour)
    )
    vim.cmd(
        "hi "
        .. pane
        .. "Title"
        .. " guibg="
        .. get_hi_group_bg("TelescopeBorder")
        .. " guifg="
        .. get_hi_group_fg("rainbowcol" .. colour)
    )
    available_colours:remove(colour)
end
