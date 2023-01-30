local components = require("plugins.statusline.components")
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg

return {
    components.SingleSpace("Normal"),

    components.Semicircle("left", {
        hl = {
            fg = get_hi_group_bg("StatusLine"),
            bg = get_hi_group_bg("Normal"),
        },
    }),

    components.FillSpace,

    components.FileName,

    components.FillSpace,

    components.Semicircle("right", {
        hl = {
            fg = get_hi_group_bg("StatusLine"),
            bg = get_hi_group_bg("Normal"),
        },
    }),

    components.SingleSpace("Normal"),
}
