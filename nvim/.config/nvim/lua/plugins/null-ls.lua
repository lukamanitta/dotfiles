local null_ls = require("null-ls")
local fn = vim.fn

null_ls.setup({
    sources = {
        -- Diagnostics
        null_ls.builtins.diagnostics.eslint_d,
        -- null_ls.builtins.diagnostics.eslint,

        null_ls.builtins.diagnostics.markdownlint,

        null_ls.builtins.diagnostics.pylint.with({
            -- Remove docstring checks
            extra_args = { "--disable=C0114,C0115,C0116" },
        }),

        null_ls.builtins.diagnostics.shellcheck,

        -- Code Actions
        null_ls.builtins.code_actions.eslint_d,

        null_ls.builtins.code_actions.shellcheck,

        -- Fixers
        null_ls.builtins.formatting.trim_whitespace.with({
            disabled_filetypes = { "markdown" },
        }),

        null_ls.builtins.formatting.trim_newlines,

        null_ls.builtins.formatting.prettier.with({
            filetypes = { "typescript", "json", "yaml", "svelte", "scss", "graphql", "css" },
        }),
        null_ls.builtins.formatting.markdownlint,

        null_ls.builtins.formatting.stylua.with({
            extra_args = {
                "--config-path",
                fn.expand("~/.config/nvim/.stylua.toml"),
                --     -- '--search-parent-directories',
            },
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
            extra_args = { "-c", fn.expand("~/.uncrustify.cfg"), "--no-backup" },
        }),

        null_ls.builtins.formatting.rustfmt,

        null_ls.builtins.formatting.black,

        null_ls.builtins.formatting.eslint_d,
    },
    on_attach = function(client)
        if client.resolved_capabilities.document_formatting then
            vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync(nil, 3000)
            augroup END
            ]])
        end
    end,
})
