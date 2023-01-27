local cmd = vim.cmd

local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg
local colourscheme = require("settings.globals").colourscheme

local require_path = colourscheme:gsub("_", ".")

require("plugins.colourschemes." .. require_path)

if vim.o.laststatus == 3 then
    cmd("hi WinSeparator guibg=None guifg=" .. get_hi_group_bg("StatusLine"))
end

require("plugins.colourschemes.custom_hl")
require("plugins.statusline.lualine")
require("plugins.ui.cokeline")

-- Transparency
vim.cmd(
    "hi StableNormal guibg="
    .. get_hi_group_bg("Normal")
    .. " guifg="
    .. get_hi_group_fg("Normal")
)

if require("settings.globals").transparent_bg then
    vim.cmd("hi Normal ctermbg=NONE guibg=NONE")
end
