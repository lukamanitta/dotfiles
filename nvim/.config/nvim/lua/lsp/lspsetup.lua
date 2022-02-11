local cmd = vim.cmd

local on_attach = function(_, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings
    local opts = { noremap = true, silent = true }

    -- Built-in LSP
    buf_set_keymap('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>', opts)

    -- Lspsaga
    buf_set_keymap('n', '<leader>ca', ':Lspsaga code_action<CR>', opts)
    buf_set_keymap('n', '<leader>rn', ':Lspsaga rename<CR>', opts)
    buf_set_keymap('n', 'K', ':Lspsaga hover_doc<CR>', opts)
    buf_set_keymap('n', '<leader>sh', ':Lspsaga signature_help<CR>', opts)
    buf_set_keymap('n', ']e', ':Lspsaga diagnostic_jump_next<CR>', opts)
    buf_set_keymap('n', '[e', ':Lspsaga diagnostic_jump_prev<CR>', opts)
    buf_set_keymap('n', '<leader>d', ':Lspsaga show_cursor_diagnostics<CR>', opts)

    -- Trouble
    buf_set_keymap('n', 'gr', ':Trouble lsp_references<CR>', opts)
    buf_set_keymap('n', '<leader>xw', ':Trouble workspace_diagnostics<CR>', opts)
    buf_set_keymap('n', '<leader>xd', ':Trouble document_diagnostics<CR>', opts)
end

cmd([[
augroup lspAutocmds
    au!
    autocmd CursorHoldI * silent! Lspsaga signature_help
]])

-- Configure lua language server for neovim development
local lua_settings = {
    Lua = {
        runtime = {
            -- LuaJIT in the case of Neovim
            version = 'LuaJIT',
            path = vim.split(package.path, ';'),
        },
        diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { 'vim', 'use' },
            disable = { 'trailing-space' },
        },
        workspace = {
            -- Make the server aware of Neovim runtime files
            library = {
                [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
            },
        },
    },
}

-- Config that activates keymaps and enables snippet support
local function make_config()
    local capabilities = require('cmp_nvim_lsp').update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
    )
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return {
        -- Enable snippet support
        capabilities = capabilities,
        -- Map buffer local keybindings when the language server attaches
        on_attach = on_attach,
    }
end

local lsp_installer = require('nvim-lsp-installer')

lsp_installer.on_server_ready(function(server)
    local config = make_config()

    if server.name == 'sumneko_lua' then
        config.settings = lua_settings
    end
    -- TODO: Get emmet_ls working for jsx files
    if server.name == 'emmet_ls' then
        config.filetypes = { 'html', 'css', 'svelte', 'javascriptreact' }
    end

    -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
    server:setup(config)
    vim.cmd([[ do User LspAttachBuffers ]])
end)
