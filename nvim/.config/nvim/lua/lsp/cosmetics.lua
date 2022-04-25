local cmd, fn = vim.cmd, vim.fn
local lsp_icons = require("assets.icons").lsp

vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = false,
    virtual_text = false,
    -- virtual_text = {
    --     prefix = '●', -- Could be '●', '▎', 'x', '■'
    -- }
})

fn.sign_define("DiagnosticSignError", {
    text = lsp_icons.Error .. " ",
    texthl = "DiagnosticError",
})
fn.sign_define("DiagnosticSignWarn", { text = lsp_icons.Warn .. " ", texthl = "DiagnosticWarn" })
fn.sign_define("DiagnosticSignHint", { text = lsp_icons.Hint .. " ", texthl = "DiagnosticHint" })
fn.sign_define("DiagnosticSignInfo", { text = lsp_icons.Info .. " ", texthl = "DiagnosticInfo" })
fn.sign_define("LightBulbSign", { text = lsp_icons.CodeAction .. " ", texthl = "DiagnosticWarn" })
