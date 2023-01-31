local cmd = vim.cmd
local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg

cmd("hi! @function.call gui=bold guifg=" .. get_hi_group_fg("Function"))

local random_range = require("utils.math").random_range

local float_blend = require("settings.globals").float_blend

vim.cmd(
    "hi FloatBorder guibg="
    .. get_hi_group_bg("Normal")
    .. " guifg="
    .. get_hi_group_fg("rainbowcol" .. random_range(1, 7, os.time()))
    .. " blend="
    .. float_blend
)
vim.cmd(
    "hi NormalFloat guibg="
    .. get_hi_group_bg("Normal")
    .. " blend="
    .. float_blend
)
vim.cmd(
    "hi FloatTitle guibg="
    .. get_hi_group_bg("Normal")
    .. " blend="
    .. float_blend
)

local background = get_hi_group_bg("Normal")
local multiply_hex_brightness = require("utils.color").multiply_hex_brightness

-- Cursorline

vim.cmd("hi! CursorLine guibg=" .. multiply_hex_brightness(background, -0.1))

-- Bars (statusline, bufferline)
local focused_tab_brightness_diff = 0.55
if vim.o.background == "light" then
    focused_tab_brightness_diff = -0.07
end
local unfocused_tab_brightness_diff = -0.35
if vim.o.background == "light" then
    unfocused_tab_brightness_diff = -0.2
end

local bar_highlight =
multiply_hex_brightness(background, focused_tab_brightness_diff)
local bar_highlight_2 =
multiply_hex_brightness(background, focused_tab_brightness_diff / 2)
local bar_background =
multiply_hex_brightness(background, unfocused_tab_brightness_diff)
local bar_accent =
get_hi_group_fg("rainbowcol" .. random_range(1, 7, os.time()))

vim.cmd("hi! BarBackground guibg=" .. bar_background)
vim.cmd("hi! BarHighlight guibg=" .. bar_highlight)
vim.cmd("hi! BarHighlight2 guibg=" .. bar_highlight_2)
vim.cmd("hi! BarAccent guibg=" .. bar_accent)

-- Remove Backgrounds
local remove_hl_bg = require("utils.color.hl_groups").remove_hl_bg
local hl_to_remove_bg = {
    "FloatBorder",
    "FloatTitle",
    "NormalFloat",
    "TelescopeNormal",
}

for _, hl in ipairs(hl_to_remove_bg) do
    remove_hl_bg(hl)
end
