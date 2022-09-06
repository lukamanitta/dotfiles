local null_ls = require("null-ls")
local fn = vim.fn

null_ls.setup({
    debug = false,
    sources = {
        -- Web
        null_ls.builtins.diagnostics.eslint_d,
        -- null_ls.builtins.diagnostics.eslint,

        null_ls.builtins.code_actions.eslint_d,
        -- null_ls.builtins.code_actions.eslint,

        null_ls.builtins.formatting.eslint_d,
        -- null_ls.builtins.formatting.eslint,

        null_ls.builtins.formatting.prettier.with({
            filetypes = {
                -- "typescript",
                "json",
                -- "yaml",
                "svelte",
                "scss",
                "graphql",
                "css",
            },
        }),

        -- Markdown
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.formatting.markdownlint,

        -- Lua
        null_ls.builtins.formatting.stylua.with({
            extra_args = {
                "--config-path",
                fn.expand("~/.config/nvim/.stylua.toml"),
                -- '--search-parent-directories',
            },
        }),

        -- C-Like
        null_ls.builtins.formatting.uncrustify.with({
            extra_args = {
                "-c",
                fn.expand("~/.uncrustify.cfg"),
                "--no-backup",
            },
        }),

        null_ls.builtins.formatting.clang_format.with({
            filetypes = { "c" },
            extra_args = {
                "-style=file",
            },
        }),

        -- Python
        null_ls.builtins.diagnostics.pylint.with({
            -- Remove docstring checks
            extra_args = { "--disable=C0114,C0115,C0116" },
        }),

        null_ls.builtins.formatting.black,

        -- Rust
        null_ls.builtins.formatting.rustfmt,

        -- Shell
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.code_actions.shellcheck,

        -- Misc
        null_ls.builtins.formatting.trim_whitespace.with({
            disabled_filetypes = { "markdown" },
        }),

        null_ls.builtins.formatting.trim_newlines,
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
