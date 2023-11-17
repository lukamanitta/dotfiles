local U = {}

function U.clamp(value, min, max)
    if value < min then
        return min
    end
    if value > max then
        return max
    end
    return value
end

function U.random_range(min, max, seed)
    if seed then
        math.randomseed(seed)
    end
    return math.random(min, max)
end

return U
