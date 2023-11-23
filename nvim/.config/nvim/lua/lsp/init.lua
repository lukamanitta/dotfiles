local lspconfig = require("lspconfig")

local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, noremap = true, silent = true }
    -- Navigation
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "[e", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]e", vim.diagnostic.goto_next, opts)

    -- Information
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<LEADER>K", vim.diagnostic.open_float, opts)

    -- Alteration
    vim.keymap.set('n', '<LEADER>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<LEADER>ca', vim.lsp.buf.code_action, opts)
end

local function make_config()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    -- capabilities.textDocument.completion.completionItem.snippetSupport = true
    return {
        capabilities = capabilities,
        on_attach = on_attach
    }
end

-- TODO: maybe bootstrap these
lspconfig.tsserver.setup(make_config())
lspconfig.rust_analyzer.setup(make_config())
lspconfig.pyright.setup(make_config())

local lua_settings = {
    Lua = {
        runtime = {
            -- Neovim uses LuaJIT
            version = "LuaJIT",
            path = vim.split(package.path, ";"),
        },
        diagnostics = {
            -- Get LS to recognise 'vim'
            globals = { "vim" },
            disable = { "trailing-space" },
        },
        workspace = {
            -- Make LS aware of Neovim runtime files
            library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
            },
        },
        completion = {
            keywordSnippet = "Replace",
            callSnippet = "Replace",
        },
    },
}

local lua_config = make_config()
lua_config.settings = lua_settings
lspconfig.lua_ls.setup(lua_config)

require("lsp.theme")
