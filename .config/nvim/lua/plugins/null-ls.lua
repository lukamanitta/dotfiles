local null_ls = require('null-ls')
local fn = vim.fn

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.trim_whitespace,
        null_ls.builtins.formatting.trim_newlines,
        null_ls.builtins.formatting.stylua.with({
            extra_args = { '--config-path', fn.expand('~/.config/nvim/.stylua.toml') },
        }),
        null_ls.builtins.formatting.clang_format.with({
            extra_args = {
                [["
                    -style='{
                        BasedOnStyle: LLVM,
                        IndentWidth: 4,
                        AlignAfterOpenBracket: DontAlign,
                        ContinuationIndentWidth: 8,
                    }'
                "]],
            },
        }),
        null_ls.builtins.formatting.uncrustify.with({
            extra_args = { '-c', fn.expand('~/.uncrustify.cfg'), '--no-backup' },
        }),
        null_ls.builtins.formatting.rustfmt,
        null_ls.builtins.formatting.black.with({
            command = 'python -m black',
        }),
        null_ls.builtins.formatting.eslint_d,
    },
    on_attach = function(client)
        if client.resolved_capabilities.document_formatting then
            vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
            augroup END
            ]])
        end
    end,
})
