local U = {}

function U.set_scope_opts(scope, opts)
    for k, v in pairs(opts) do
        scope[k] = v
    end
end

function U.shell(command)
    return vim.fn.trim(vim.fn.system(command))
end

function U.get_hl(hl_name, prop)
    return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hl_name)), prop)
end

function U.get_buf_filetype(bufnr)
    return vim.api.nvim_get_option_value("filetype", { buf = bufnr })
end

function U.get_buf_icon(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local file_ext = string.match(filename, "(%w+)$")
    local default_icon = ""
    return require("nvim-material-icon").get_icon(
        filename,
        file_ext,
        { default = default_icon }
    )
end

function U.get_buf_icon_colour(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local file_ext = string.match(filename, "(%w+)$")
    local default_icon = ""
    return require("nvim-material-icon").get_icon_color(
        filename,
        file_ext,
        { default = default_icon }
    )
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

function U.table_has_value(table, value)
    table = table or {}
    if table == {} then
        return false
    end
    for _, existing_val in ipairs(table) do
        if existing_val == value then
            return true
        end
    end
    return false
end

return U
