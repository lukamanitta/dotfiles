local C = {}
local conversions = require('utils.color.conversions')

function C.invert_hex_color(color)
    local r, g, b = color:match('#(%x%x)(%x%x)(%x%x)')
    return string.format(
        '#%02X%02X%02X',
        255 - tonumber(r, 16),
        255 - tonumber(g, 16),
        255 - tonumber(b, 16)
    )
end

function C.change_hex_brightness(color, multiplier)
    local r, g, b = color:match('#(%x%x)(%x%x)(%x%x)')

    local h, s, v, a = conversions.rgb_to_hsv(r, g, b)
    local new_v = v + (v * multiplier)
    local new_r, new_g, new_b = conversions.hsv_to_rgb(h, s, new_v, a)

    return string.format('#%02X%02X%02X', new_r, new_g, new_b)
end

return C