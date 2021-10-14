local api, cmd, fn = vim.api, vim.cmd, vim.fn
local F = {}

function F.open_file_in_prev_window()
    local hovered_file = fn.expand('<cfile>')
    cmd('wincmd p')
    cmd(string.format('e %s', hovered_file))
end

function F.trim_whitespace()
    local cursor_pos = api.nvim_win_get_cursor(0)
    cmd('keeppatterns %s/\\s\\+$//e')
    api.nvim_win_set_cursor(0, cursor_pos)
end

-- function F.startup_layout()
--     cmd 'split | resize 10 | setl wfh | execute "term" | wincmd p'
-- end

-- Only works when run manually for some reason
function F.install_lsp_servers()
    local servers = {
        'bash',
        'csharp',
        'css',
        'graphql',
        'html',
        'json',
        'latex',
        'lua',
        'python',
        'ruby',
        'rust',
        'typescript',
        'vim',
        'yaml',
    }

    for _, server in ipairs(servers) do
        cmd(string.format(':lspinstall %s', server))
    end
end

return F
