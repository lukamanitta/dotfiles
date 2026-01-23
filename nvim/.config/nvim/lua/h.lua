local U = {}

function U.table_has_value(t, desired_v)
    t = t or {}
    if t == {} then
        return false
    end
    for _, v in ipairs(t) do
        if v == desired_v then
            return true
        end
    end
    return false
end

function U.overwrite_keys(t, keys)
    for k, v in pairs(keys) do
        t[k] = v
    end
end

function U.table_merge(into, from)
    local stack = {}
    local node1 = into
    local node2 = from
    while true do
        for k, v in pairs(node2) do
            if type(v) == "table" and type(node1[k]) == "table" then
                table.insert(stack, { node1[k], node2[k] })
            else
                node1[k] = v
            end
        end
        if #stack > 0 then
            local t = stack[#stack]
            node1, node2 = t[1], t[2]
            stack[#stack] = nil
        else
            break
        end
    end
    return into
end

function U.get_hl(hl_name, prop)
    return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hl_name)), prop)
end

function U.get_buf_filetype(bufnr)
    return vim.api.nvim_get_option_value("filetype", { buf = bufnr })
end

-- get buf icon?
-- get buf icon colour?

return U
