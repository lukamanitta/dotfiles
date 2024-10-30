local lspconfig = require("lspconfig")

local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, noremap = true, silent = true }
    -- Navigation
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "[e", function() vim.diagnostic.jump({ count = -1 }) end, opts)
    vim.keymap.set("n", "]e", function() vim.diagnostic.jump({ count = 1 }) end, opts)

    -- Information
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<LEADER>K", vim.diagnostic.open_float, opts)
    -- vim.keymap.set("n", "<LEADER>d", vim.diagnostic.show_line_diagnostics, opts)

    -- Alteration
    vim.keymap.set("n", "<LEADER>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<LEADER>ca", vim.lsp.buf.code_action, opts)

    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true)
    end

    if client.server_capabilities.semanticTokensProvider then
        client.server_capabilities.semanticTokensProvider = nil
    end
end

local function make_config()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    -- capabilities.textDocument.completion.completionItem.snippetSupport = true
    return {
        capabilities = capabilities,
        on_attach = on_attach,
    }
end

lspconfig.ts_ls.setup(make_config())
lspconfig.rust_analyzer.setup(make_config())
lspconfig.pyright.setup(make_config())
lspconfig.svelte.setup(make_config())
lspconfig.gdscript.setup(make_config())
lspconfig.gdshader_lsp.setup(make_config())

local lua_config = make_config()
lua_config.settings = require("lsp.server_settings.lua_ls")
lspconfig.lua_ls.setup(lua_config)

require("lsp.theme")
