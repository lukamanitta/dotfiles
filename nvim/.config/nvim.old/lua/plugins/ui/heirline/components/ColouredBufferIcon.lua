local get_buf_icon_colour = require("helpers").get_buf_icon_colour
local get_buf_icon = require("helpers").get_buf_icon

return function(bufnr)
    return {
        provider = function()
            return " " .. get_buf_icon(bufnr) .. " "
        end,
        hl = function()
            local _, colour = get_buf_icon_colour(bufnr)
            return {
                fg = colour,
            }
        end,
    }
end
