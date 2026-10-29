-- Remove default LSP keymaps
pcall(vim.keymap.del, "n", "gri")
pcall(vim.keymap.del, "n", "grt")
pcall(vim.keymap.del, "n", "grr")
pcall(vim.keymap.del, "n", "grn")
pcall(vim.keymap.del, { "n", "v" }, "gra")
pcall(vim.keymap.del, "n", "grx")

-- Treesitter highlighting is preferred over LSP semantic highlighting.
vim.lsp.semantic_tokens.enable(false)

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_attach_config", { clear = true }),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local bufnr = args.buf
        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(
                mode,
                lhs,
                rhs,
                { buf = bufnr, silent = true, desc = desc }
            )
        end

        -- Navigation
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        map("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")
        map("n", "[e", function()
            vim.diagnostic.jump({ count = -1 })
        end, "Previous diagnostic")
        map("n", "]e", function()
            vim.diagnostic.jump({ count = 1 })
        end, "Next diagnostic")

        -- Information
        map({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, "Signature help")
        map("n", "gr", vim.lsp.buf.references, "References")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "<LEADER>K", vim.diagnostic.open_float, "Show diagnostics")

        -- Modification
        map("n", "<LEADER>rn", vim.lsp.buf.rename, "Rename symbol")
        map({ "n", "v" }, "<LEADER>ca", vim.lsp.buf.code_action, "Code action")
        map({ "n", "v" }, "<LEADER>cl", vim.lsp.codelens.run, "Run codelens")

        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
    end,
})

-- Default config
-- vim.lsp.config("*", {
--     capabilities = require("blink.cmp").get_lsp_capabilities(),
-- })
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

vim.lsp.enable("ruby_lsp")

require("lsp.theme")
