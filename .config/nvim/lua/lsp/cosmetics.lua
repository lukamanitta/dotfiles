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

-- local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ', CodeAction = '' }
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ', CodeAction = '' }
fn.sign_define('LspDiagnosticsSignError', { text = signs.Error, texthl = 'DiagnosticError' })
fn.sign_define('LspDiagnosticsSignWarning', { text = signs.Warn, texthl = 'DiagnosticWarn' })
fn.sign_define('LspDiagnosticsSignHint', { text = signs.Hint, texthl = 'DiagnosticHint' })
fn.sign_define('LspDiagnosticsSignInformation', { text = signs.Info, texthl = 'DiagnosticInfo' })
-- fn.sign_define('LightBulbSign', { text = signs.CodeAction, texthl = 'DiagnosticWarn' })
vim.cmd('hi link ALEWarningSign DiagnosticWarn')
vim.cmd('hi link ALEInfoSign DiagnosticInfo')

local comp_icons = {
    Class = ' ',
    Color = ' ',
    Constant = ' ',
    Constructor = ' ',
    Enum = '了 ',
    EnumMember = ' ',
    Field = ' ',
    File = ' ',
    Folder = ' ',
    Function = ' ',
    Interface = 'ﰮ ',
    Keyword = ' ',
    Method = ' ',
    Module = ' ',
    Property = ' ',
    Snippet = '﬌ ',
    Struct = ' ',
    Text = ' ',
    Unit = ' ',
    Value = ' ',
    Variable = ' ',
}

local kinds = vim.lsp.protocol.CompletionItemKind
for i, kind in ipairs(kinds) do
    kinds[i] = comp_icons[kind] or kind
end
