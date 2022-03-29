local api, cmd, fn = vim.api, vim.cmd, vim.fn
local F = {}

-- Only works when run manually for some reason
function F.install_lsp_servers()
    local servers = {
        "vimls",
        "yamlls",
        "cssls",
        "omnisharp",
        "bashls",
        "graphql",
        "tsserver",
        "solargraph",
        "sumneko_lua",
        "pyright",
        "zk",
        "emmet_ls",
    }
    local servers_string = ""
    for _, server in ipairs(servers) do
        servers_string = servers_string .. " " .. server
    end
    cmd(":LspInstall" .. servers_string)
end

return F
