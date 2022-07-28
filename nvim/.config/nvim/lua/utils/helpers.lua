local H = {}
local fn = vim.fn
local cmd = vim.cmd

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

function H.course_regex()
    vim.notify(fn.expand("%"))
    cmd('echo expand("%")')
    return H.shell('echo "' .. fn.expand("%") .. "\" | egrep -o '[A-Z]{4}[0-9]{4}' | tail -1")
end

return H
