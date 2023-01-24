local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg

if require("settings.globals").float_style == "flat" then
    vim.cmd(
        "hi! NoiceCmdlinePopup guibg="
        .. get_hi_group_bg("StatusLine")
        .. " guifg="
        .. get_hi_group_fg("StatusLine")
        .. " gui=bold"
    )
elseif require("settings.globals").float_style == "classic" then
    vim.cmd(
        "hi! NoiceCmdlinePopup guibg="
        .. get_hi_group_bg("Normal")
        .. " guifg="
        .. get_hi_group_fg("Normal")
        .. " gui=bold"
    )
end
