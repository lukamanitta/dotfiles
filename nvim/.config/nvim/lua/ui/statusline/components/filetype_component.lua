local U = require("h")
local hl = require("ui.statusline.hl")

return function()
    local icon, icon_hl = U.get_buf_icon()

    return hl.hl(icon_hl, icon .. " ")
        .. hl.hl("StatusLine", U.get_buf_filetype())
end
