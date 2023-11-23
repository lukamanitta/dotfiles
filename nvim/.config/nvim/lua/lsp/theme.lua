local lsp_icons = require("icons").lsp

vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = true,
    virtual_lines = false,
    -- virtual_text = false,
    virtual_text = {
        prefix = "●", -- Could be '●', '▎', '■'
        source = "if_many",
        spacing = 1,
    },
})

vim.fn.sign_define("DiagnosticSignError", {
    text = lsp_icons.Error .. " ",
    texthl = "DiagnosticError",
})

vim.fn.sign_define(
    "DiagnosticSignWarn",
    { text = lsp_icons.Warn .. " ", texthl = "DiagnosticWarn" }
)

vim.fn.sign_define(
    "DiagnosticSignHint",
    { text = lsp_icons.Hint .. " ", texthl = "DiagnosticHint" }
)

vim.fn.sign_define(
    "DiagnosticSignInfo",
    { text = lsp_icons.Info .. " ", texthl = "DiagnosticInfo" }
)

vim.fn.sign_define(
    "LightBulbSign",
    { text = lsp_icons.CodeAction .. " ", texthl = "DiagnosticWarn" }
)
