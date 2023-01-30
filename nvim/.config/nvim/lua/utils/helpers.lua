local H = {}

function H.shell(command)
    return vim.fn.trim(vim.fn.system(command))
end

function H.inside_git_dir()
    local _ = H.shell("git rev-parse --is-inside-git-dir")
    return vim.v.shell_error == 0
end

function H.get_buf_filetype(bufId)
    return vim.api.nvim_buf_get_option(bufId, "filetype")
end

function H.apply_options(opts)
    for k, v in pairs(opts) do
        if v == true then
            vim.cmd("set " .. k)
        elseif v == false then
            vim.cmd(string.format("set no%s", k))
        else
            vim.cmd(string.format("set %s=%s", k, v))
        end
    end
end

function H.apply_globals(opts)
    for k, v in pairs(opts) do
        vim.g[k] = v
    end
end

function H.get_buf_icon(bufnr)
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

function H.get_buf_icon_colour(bufnr)
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

return H
