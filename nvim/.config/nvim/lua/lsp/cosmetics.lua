local cmd, fn = vim.cmd, vim.fn
local lspIcons = require('assets.icons').lsp

vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = false,
    virtual_text = false,
    -- virtual_text = {
    --     prefix = '●', -- Could be '●', '▎', 'x', '■'
    -- }
})

-- local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ', CodeAction = '' }
fn.sign_define('DiagnosticSignError', { text = lspIcons.Error, texthl = 'DiagnosticError' })
fn.sign_define('DiagnosticSignWarn', { text = lspIcons.Warn, texthl = 'DiagnosticWarn' })
fn.sign_define('DiagnosticSignHint', { text = lspIcons.Hint, texthl = 'DiagnosticHint' })
fn.sign_define('DiagnosticSignInfo', { text = lspIcons.Info, texthl = 'DiagnosticInfo' })
fn.sign_define('LightBulbSign', { text = lspIcons.CodeAction, texthl = 'DiagnosticWarn' })
