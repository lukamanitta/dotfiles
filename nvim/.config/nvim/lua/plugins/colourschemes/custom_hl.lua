local cmd = vim.cmd
local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg

cmd("hi! @function.call gui=bold guifg=" .. get_hi_group_fg("Function"))
