local cmd, fn = vim.cmd, vim.fn
local icons = require('assets.icons')

vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = true,
    virtual_text = false,
    -- virtual_text = {
    --     prefix = '●', -- Could be '●', '▎', 'x', '■'
    -- }
})
--
-- local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ', CodeAction = '' }
fn.sign_define('DiagnosticSignError', { text = icons.LspError, texthl = 'DiagnosticError' })
fn.sign_define('DiagnosticSignWarn', { text = icons.LspWarn, texthl = 'DiagnosticWarn' })
fn.sign_define('DiagnosticSignHint', { text = icons.LspHint, texthl = 'DiagnosticHint' })
fn.sign_define('DiagnosticSignInfo', { text = icons.LspInfo, texthl = 'DiagnosticInfo' })
fn.sign_define('LightBulbSign', { text = icons.LspCodeAction, texthl = 'DiagnosticWarn' })
