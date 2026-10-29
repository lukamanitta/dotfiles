local M = {}

function M.hl(group, text)
    return string.format("%%#%s#%s%%*", group, text)
end

return M
