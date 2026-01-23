local table_merge = require("helpers").table_merge
local get_hl = require("helpers").get_hl
local props = require("plugins.ui.heirline.props")

return table_merge({
    {
        provider = function()
            return "%2("
                .. require("plugins.ui.heirline.helpers").mode_shortname()
                .. "%) "
        end,
        hl = {
            bold = true,
        },
    },
}, props.mode_colour_bg(get_hl("StatusLine", "bg#")))
