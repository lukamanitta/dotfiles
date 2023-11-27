local tables = require("utils.tables")
local get_hl = require("helpers").get_hl
local props = require("plugins.ui.heirline.props")

return tables.table_merge({
    -- {
    --     provider = function()
    --         return " " .. require("icons").companies.Vim .. " "
    --     end,
    -- },

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
