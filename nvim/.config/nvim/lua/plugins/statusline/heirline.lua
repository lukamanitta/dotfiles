local helpers = require("plugins.statusline.helpers")
local components = require("plugins.statusline.components")
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg

require("heirline").setup({
    statusline = {
        components.SingleSpace("Normal"),
        helpers.bubble_this(components.ModeIndicator, {
            get_hi_group_bg("Normal"),
            get_hi_group_bg("StatusLine"),
        }),
        components.SingleSpace("StatusLine"),
        helpers.bubble_this(components.FileName),
        components.SingleSpace("Normal"),
    },
})
