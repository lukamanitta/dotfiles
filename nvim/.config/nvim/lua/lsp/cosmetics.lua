local lsp_icons = require("assets.icons").lsp

vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = false,
    virtual_lines = {
        only_current_line = true,
    },
    virtual_text = false,
    -- virtual_text = {
    --     prefix = "●", -- Could be '●', '▎', 'x', '■'
    -- },
})

vim.fn.sign_define("DiagnosticSignError", {
    text = lsp_icons.Error .. " ",
    texthl = "DiagnosticError",
})
vim.cmd("hi DiagnosticError gui=bold")

vim.fn.sign_define(
    "DiagnosticSignWarn",
    { text = lsp_icons.Warn .. " ", texthl = "DiagnosticWarn" }
)
vim.cmd("hi DiagnosticWarn gui=bold")

vim.fn.sign_define(
    "DiagnosticSignHint",
    { text = lsp_icons.Hint .. " ", texthl = "DiagnosticHint" }
)
vim.cmd("hi DiagnosticHint gui=bold")

vim.fn.sign_define(
    "DiagnosticSignInfo",
    { text = lsp_icons.Info .. " ", texthl = "DiagnosticInfo" }
)
vim.cmd("hi DiagnosticInfo gui=bold")

vim.fn.sign_define(
    "LightBulbSign",
    { text = lsp_icons.CodeAction .. " ", texthl = "DiagnosticWarn" }
)
vim.cmd("hi LightBulbSign gui=bold")
