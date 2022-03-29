local Set = { items = {} }
local has_value = require("utils.helpers").has_value

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

function Set:contains(item)
    return has_value(self.items, item)
end

function Set:size()
    return #self.items
end

function Set:is_empty()
    return #self.items == 0
end

function Set:clear()
    self.items = {}
end

function Set:union(other_set)
    local union_set = Set:new()
    for _, item in ipairs(self.items) do
        union_set:add(item)
    end
    for _, item in ipairs(other_set.items) do
        union_set:add(item)
    end
    return union_set
end

function Set:intersection(other_set)
    local intersection_set = Set:new()
    for _, item in ipairs(self.items) do
        if other_set:contains(item) then
            intersection_set:add(item)
        end
    end
    return intersection_set
end

function Set:difference(other_set)
    local difference_set = Set:new()
    for _, item in ipairs(self.items) do
        if other_set:contains(item) == false then
            difference_set:add(item)
        end
    end
    return difference_set
end

function Set:is_subset(other_set)
    for _, item in ipairs(self.items) do
        if other_set:contains(item) == false then
            return false
        end
    end
    return true
end

function Set:is_superset(other_set)
    return other_set:is_subset(self)
end

function Set:is_disjoint(other_set)
    for _, item in ipairs(self.items) do
        if other_set:contains(item) then
            return false
        end
    end
    return true
end

function Set:is_equal(other_set)
    if self:size() ~= other_set:size() then
        return false
    end
    for _, item in ipairs(self.items) do
        if other_set:contains(item) == false then
            return false
        end
    end
    return true
end

function Set:serialize()
    local str = "{"
    for _, item in ipairs(self.items) do
        str = str .. item .. ", "
    end
    str = str:sub(1, -3) .. "}"
    return str
end

function Set:to_string()
    local str = ""
    for _, item in ipairs(self.items) do
        str = str .. item .. ", "
    end
    str = str:sub(1, -3) .. ""
    return str
end

return Set
