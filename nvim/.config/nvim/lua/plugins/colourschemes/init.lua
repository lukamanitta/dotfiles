local cmd = vim.cmd

local get_hi_group_bg = require("utils.config").get_hi_group_bg
local colourscheme = require("settings.globals").colourscheme

local require_path = colourscheme:gsub("_", ".")

require("plugins.colourschemes." .. require_path)

if vim.o.laststatus == 3 then
    cmd("hi WinSeparator guibg=None guifg=" .. get_hi_group_bg("StatusLine"))
end
require("plugins.lualine")
require("plugins.cokeline")
