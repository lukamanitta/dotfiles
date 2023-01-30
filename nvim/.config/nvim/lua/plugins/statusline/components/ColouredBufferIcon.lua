local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local get_buf_icon_colour = require("utils.helpers").get_buf_icon_colour
local get_buf_icon = require("utils.helpers").get_buf_icon

return function(bufnr)
    return {
        provider = function()
            return " " .. get_buf_icon(bufnr) .. " "
        end,
        hl = function()
            local _, colour = get_buf_icon_colour(bufnr)
            return {
                fg = colour,
                -- bg = get_hi_group_bg("StatusLine"),
            }
        end,
    }
end
