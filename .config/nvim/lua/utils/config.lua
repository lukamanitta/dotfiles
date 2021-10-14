local g = vim.g
local api, cmd, fn = vim.api, vim.cmd, vim.fn
local U = {}

-- Key mapping
function U.map(mode, key, result, opts)
    opts = vim.tbl_extend('keep', opts or {}, {
        noremap = true,
        silent = true,
        expr = false,
    })
    api.nvim_set_keymap(mode, key, result, opts)
end

function U.table_contains(table, val)
    for _, value in ipairs(table) do
        if value == val then
            return true
        end
    end
    return false
end

function U.reload_config()
    local modules = { 'lsp', 'plugins', 'settings' }
    for _, moduleName in pairs(modules) do
        for packageName, _ in pairs(package.loaded) do
            if string.find(packageName, '^' .. moduleName) then
                package.loaded[packageName] = nil
            end
        end
        require(moduleName)
    end
    print('Reloaded!')
end

function U.get_buf_filetype(bufId)
    return api.nvim_buf_get_option(bufId, 'filetype')
end

function U.apply_options(opts)
    for k, v in pairs(opts) do
        if v == true then
            cmd('set ' .. k)
        elseif v == false then
            cmd(string.format('set no%s', k))
        else
            cmd(string.format('set %s=%s', k, v))
        end
    end
end

function U.apply_globals(opts)
    for k, v in pairs(opts) do
        g[k] = v
    end
end

function U.get_hi_group_bg(hi_group)
    return fn.synIDattr(fn.synIDtrans(fn.hlID(hi_group)), 'bg#')
end

function U.get_hi_group_fg(hi_group)
    return fn.synIDattr(fn.synIDtrans(fn.hlID(hi_group)), 'fg#')
end

function U.get_buf_icon(buffer)
    local filename = api.nvim_buf_get_name(buffer)
    local file_ext = string.match(filename, '(%w+)$')
    local default_icon = ''
    return require('nvim-web-devicons').get_icon(filename, file_ext, { default = default_icon })
end

function _G.check_backspace()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

return U
