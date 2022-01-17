local cmd, fn = vim.cmd, vim.fn

-- vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
--     vim.diagnostic.on_publish_diagnostics,
--     {
--         signs = true,
--         underline = true,
--         update_in_insert = true,
--         virtual_text = false,
--         -- virtual_text = {
--         --     prefix = '●', -- Could be '●', '▎', 'x', '■'
--         -- },
--     }
-- )
--
-- local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ', CodeAction = '' }
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ', CodeAction = '' }
fn.sign_define('DiagnosticSignError', { text = signs.Error, texthl = 'DiagnosticError' })
fn.sign_define('DiagnosticSignWarn', { text = signs.Warn, texthl = 'DiagnosticWarn' })
fn.sign_define('DiagnosticSignHint', { text = signs.Hint, texthl = 'DiagnosticHint' })
fn.sign_define('DiagnosticSignInfo', { text = signs.Info, texthl = 'DiagnosticInfo' })
fn.sign_define('LightBulbSign', { text = signs.CodeAction, texthl = 'DiagnosticWarn' })
