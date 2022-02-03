local Set = { items = {} }
local has_value = require('utils.helpers').has_value

function Set:new(items)
    items = items or {}
    local o = { items = {} }
    setmetatable(o, self)
    self.__index = self
    for _, item in ipairs(items) do
        Set.add(o, item)
    end
    return o
end

function Set:add(item)
    if has_value(self.items, item) == false then
        table.insert(self.items, item)
    end
end

function Set:remove(item)
    table.remove(self.items, item)
end

function Set:get_items()
    return self.items
end

return Set
