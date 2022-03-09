local C = {}

function C.invert_hex_color(color)
    local r, g, b = color:match('#(%x%x)(%x%x)(%x%x)')
    return string.format(
        '#%02X%02X%02X',
        255 - tonumber(r, 16),
        255 - tonumber(g, 16),
        255 - tonumber(b, 16)
    )
end

return C
