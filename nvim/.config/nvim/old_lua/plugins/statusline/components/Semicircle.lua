local tables = require("utils.tables")

return function(side, opts)
    local char = side == "left" and "" or ""
    return tables.table_merge({ provider = char }, opts)
end
