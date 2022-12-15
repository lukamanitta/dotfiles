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
