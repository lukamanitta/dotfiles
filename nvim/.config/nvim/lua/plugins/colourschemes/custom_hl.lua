local cmd = vim.cmd
local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg

cmd("hi! @function.call gui=bold guifg=" .. get_hi_group_fg("Function"))

local random_range = require("utils.math").random_range

vim.cmd(
    "hi FloatBorder guibg="
    .. get_hi_group_bg("Normal")
    .. " guifg="
    .. get_hi_group_fg("rainbowcol" .. random_range(1, 7, os.time()))
)
vim.cmd("hi NormalFloat guibg=" .. get_hi_group_bg("Normal"))
-- vim.cmd("hi FloatTitle guibg=" .. get_hi_group_bg("Normal"))

local background = get_hi_group_bg("Normal")
local multiply_hex_brightness = require("utils.color").multiply_hex_brightness

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
local bar_background =
multiply_hex_brightness(background, unfocused_tab_brightness_diff)
local bar_accent =
get_hi_group_fg("rainbowcol" .. random_range(1, 7, os.time()))

vim.cmd("hi! BarBackground guibg=" .. bar_background)
vim.cmd("hi! BarHighlight guibg=" .. bar_highlight)
vim.cmd("hi! BarAccent guibg=" .. bar_accent)
