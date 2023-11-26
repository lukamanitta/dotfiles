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

return U
