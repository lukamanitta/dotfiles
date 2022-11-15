local apply_globals = require("utils.helpers").apply_globals
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local multiply_hex_brightness = require("utils.color").multiply_hex_brightness

apply_globals({
    cursorword_disable_filetypes = { "Trouble", "DressingInput" },
    cursorword_min_width = 2,
    cursorword_max_width = 50,
})

local normal_background = get_hi_group_bg("Normal")

vim.cmd(
    "hi! CursorWord guibg=" .. multiply_hex_brightness(normal_background, -0.3)
)
vim.cmd("hi! CursorWord gui=bold")
