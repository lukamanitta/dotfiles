local lsp_icons = require("icons").lsp

vim.diagnostic.config({
    underline = true,
    update_in_insert = true,
    virtual_lines = false,
    -- virtual_text = false,
    virtual_text = {
        prefix = "", -- Could be '●', '▎', '■'
        source = "if_many",
        spacing = 1,
    },
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = lsp_icons.Error .. " ",
            [vim.diagnostic.severity.WARN] = lsp_icons.Warn .. " ",
            [vim.diagnostic.severity.HINT] = lsp_icons.Hint .. " ",
            [vim.diagnostic.severity.INFO] = lsp_icons.Info .. " ",
        },
    },
})
