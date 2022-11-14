local C = {}
local conversions = require("utils.color.conversions")
local mymath = require("utils.math")

function C.invert_hex_color(color)
    local r, g, b = color:match("#(%x%x)(%x%x)(%x%x)")
    return string.format(
        "#%02X%02X%02X",
        255 - tonumber(r, 16),
        255 - tonumber(g, 16),
        255 - tonumber(b, 16)
    )
end

function C.invert_hex_brightness(color)
    local r, g, b = color:match("#(%x%x)(%x%x)(%x%x)")
    local h, s, v, a = conversions.rgb_to_hsv(
        tonumber(r, 16),
        tonumber(g, 16),
        tonumber(b, 16)
    )
    local new_r, new_g, new_b = conversions.hsv_to_rgb(h, s, 1 - v, a)
    return string.format("#%02X%02X%02X", new_r, new_g, new_b)
end

function C.change_hex_brightness(color, multiplier)
    local r, g, b = color:match("#(%x%x)(%x%x)(%x%x)")

    local h, s, v, a = conversions.rgb_to_hsv(r, g, b)
    local new_v = mymath.clamp(v + (v * multiplier), 0, 1)
    local new_r, new_g, new_b = conversions.hsv_to_rgb(h, s, new_v, a)

    return string.format("#%02X%02X%02X", new_r, new_g, new_b)
end

function C.blend_rgb(base, overlay, overlayRatio)
    local r1, g1, b1 = base:match("#(%x%x)(%x%x)(%x%x)")
    local r2, g2, b2 = overlay:match("#(%x%x)(%x%x)(%x%x)")

    local r = math.floor(
        tonumber(r1, 16) * (1 - overlayRatio) + tonumber(r2, 16) * overlayRatio
    )
    local g = math.floor(
        tonumber(g1, 16) * (1 - overlayRatio) + tonumber(g2, 16) * overlayRatio
    )
    local b = math.floor(
        tonumber(b1, 16) * (1 - overlayRatio) + tonumber(b2, 16) * overlayRatio
    )

    return string.format("#%02X%02X%02X", r, g, b)
end

return C
