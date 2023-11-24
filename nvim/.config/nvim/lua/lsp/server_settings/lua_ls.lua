local U = {
    Lua = {
        runtime = {
            -- Neovim uses LuaJIT
            version = "LuaJIT",
            path = vim.split(package.path, ";"),
        },
        diagnostics = {
            -- Get LS to recognise 'vim'
            globals = { "vim" },
            disable = { "trailing-space" },
        },
        workspace = {
            -- Make LS aware of Neovim runtime files
            library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
            },
        },
        completion = {
            keywordSnippet = "Replace",
            callSnippet = "Replace",
        },
    },
}

return U
