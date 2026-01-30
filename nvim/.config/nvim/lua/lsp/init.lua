local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, noremap = true, silent = true }

    -- Navigation
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "[e", function()
        vim.diagnostic.jump({ count = -1 })
    end, opts)
    vim.keymap.set("n", "]e", function()
        vim.diagnostic.jump({ count = 1 })
    end, opts)

    -- Information
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<LEADER>K", vim.diagnostic.open_float, opts)

    -- Modification
    vim.keymap.set("n", "<LEADER>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<LEADER>ca", vim.lsp.buf.code_action, opts)

    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true)
    end

    if client.server_capabilities.semanticTokensProvider then
        client.server_capabilities.semanticTokensProvider = nil
    end
end

-- Default config
vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    on_attach = on_attach,
})
-- Per-server config in after/lsp/

-- NOT NECESSARY WITH MASON-LSPCONFIG
-- Enable servers corresponding to filenames in lsp/
-- local lsp_configs = {}
-- for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
--     if not f:find("init") or f:find("theme") then
--         local server_name = vim.fn.fnamemodify(f, ':t:r')
--         table.insert(lsp_configs, server_name)
--     end
-- end
-- vim.lsp.enable(lsp_configs)

require("lsp.theme")
