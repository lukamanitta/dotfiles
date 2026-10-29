local U = {}

function U.overwrite_keys(t, keys)
    for k, v in pairs(keys) do
        t[k] = v
    end
end

function U.get_hl(hl_name, prop)
    return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hl_name)), prop)
end

function U.set_hl(hl_name, opts)
    vim.api.nvim_set_hl(0, hl_name, opts)
end

function U.mod_hl(hl_name, opts)
    local is_ok, hl_def =
        pcall(vim.api.nvim_get_hl, 0, { name = hl_name, create = false })
    if is_ok then
        for k, v in pairs(opts) do
            hl_def[k] = v
        end
        vim.api.nvim_set_hl(0, hl_name, hl_def)
    end
end

function U.get_buf_filetype(bufnr)
    return vim.api.nvim_get_option_value("filetype", { buf = bufnr })
end

function U.get_buf_icon(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    local filetype = U.get_buf_filetype(bufnr)
    if filetype == "TelescopePrompt" then
        return "", "TelescopePromptPrefix"
    elseif filetype == "neo-tree" then
        return "", "NeogitGraphGreen"
    end

    local filename = vim.api.nvim_buf_get_name(bufnr)
    local file_ext = string.match(filename, "(%w+)$")
    local default_icon = ""
    return require("nvim-web-devicons").get_icon(
        filename,
        file_ext,
        { default = default_icon }
    )
end

function U.get_visual_selection()
    local mode = vim.api.nvim_get_mode().mode

    local lines = vim.fn.getregion(
        vim.fn.getpos("v"),
        vim.fn.getpos("."),
        { type = mode }
    )

    return table.concat(lines, "\n")
end

function U.git_root_or_cwd()
    local git_root = vim.fs.root(0, ".git")
    return git_root or vim.fn.getcwd()
end

return U
