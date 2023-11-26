return function(fg)
    return {
        hl = function()
            local colour = require("plugins.heirline.helpers").mode_colour()
            return { bg = colour, fg = fg }
        end,
        -- update = "ModeChanged",
    }
end
