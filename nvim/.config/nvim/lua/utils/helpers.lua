local H = {}
local fn = vim.fn

function H.has_value(table, value)
    table = table or {}
    if table == {} then
        return false
    end
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

function H.shell(command)
    return fn.trim(fn.system(command))
end

function H.split_file_path(filepath)
    -- Returns the Path, Filename, and Extension as 3 values
    return string.match(filepath, "(.-)([^\\]-([^\\%.]+))$")
end

return H
