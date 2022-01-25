local api, cmd, fn = vim.api, vim.cmd, vim.fn
local F = {}

function F.open_file_in_prev_window()
    local hovered_file = fn.expand('<cfile>')
    cmd('wincmd p')
    cmd(string.format('e %s', hovered_file))
end

-- Only works when run manually for some reason
function F.install_lsp_servers()
    local servers = {
        'bashls',
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
        'java',
    }
    local servers_string = ''
    for _, server in ipairs(servers) do
        servers_string = servers_string .. ' ' .. server
    end
    cmd(':LspInstall ' .. servers_string)
end

return F
