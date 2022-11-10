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

function U.random_range(min, max)
    math.randomseed(os.time())
    return math.random(min, max)
end

return U
