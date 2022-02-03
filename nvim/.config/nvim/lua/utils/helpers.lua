local H = {}

function H.has_value(table, value)
    for _, existingVal in ipairs(table) do
        if existingVal == value then
            return true
        end
    end
    return false
end

function H.table_length(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

return H
