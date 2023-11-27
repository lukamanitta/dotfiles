local U = {}
local conversions = require("utils.color.conversions")

local function clamp(value, min, max)
    if value < min then
        return min
    end
    if value > max then
        return max
    end
    return value
end


function U.invert_hex_color(color)
    local r, g, b = color:match("#(%x%x)(%x%x)(%x%x)")
    return string.format(
        "#%02X%02X%02X",
        255 - tonumber(r, 16),
        255 - tonumber(g, 16),
        255 - tonumber(b, 16)
    )
end

function U.invert_hex_brightness(color)
    local r, g, b = color:match("#(%x%x)(%x%x)(%x%x)")
    local h, s, v, a = conversions.rgb_to_hsv(
        tonumber(r, 16),
        tonumber(g, 16),
        tonumber(b, 16)
    )
    local new_r, new_g, new_b = conversions.hsv_to_rgb(h, s, 1 - v, a)
    return string.format("#%02X%02X%02X", new_r, new_g, new_b)
end

function U.multiply_hex_brightness(color, multiplier)
    local r, g, b = color:match("#(%x%x)(%x%x)(%x%x)")

    local h, s, v, a = conversions.rgb_to_hsv(r, g, b)
    local new_v = clamp(v + (v * multiplier), 0, 1)
    local new_r, new_g, new_b = conversions.hsv_to_rgb(h, s, new_v, a)

    return string.format("#%02X%02X%02X", new_r, new_g, new_b)
end

function U.blend_hex(base, overlay, overlay_ratio)
    local r1, g1, b1 = base:match("#(%x%x)(%x%x)(%x%x)")
    local r2, g2, b2 = overlay:match("#(%x%x)(%x%x)(%x%x)")

    local r = math.floor(
        tonumber(r1, 16) * (1 - overlay_ratio) + tonumber(r2, 16) * overlay_ratio
    )
    local g = math.floor(
        tonumber(g1, 16) * (1 - overlay_ratio) + tonumber(g2, 16) * overlay_ratio
    )
    local b = math.floor(
        tonumber(b1, 16) * (1 - overlay_ratio) + tonumber(b2, 16) * overlay_ratio
    )

    return string.format("#%02X%02X%02X", r, g, b)
end

return U
