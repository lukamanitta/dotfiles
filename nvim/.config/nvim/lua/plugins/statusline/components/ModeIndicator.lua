local tables = require("utils.tables")
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local props = require("plugins.statusline.props")

return tables.table_merge({
    provider = function()
        return require("assets.icons").general.Heart .. " "
    end,
}, props.mode_colour_bg(get_hi_group_bg("StatusLine")))
