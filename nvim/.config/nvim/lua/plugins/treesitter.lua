require("nvim-treesitter.configs").setup({
    -- ensure_installed = 'maintained', -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    disable = { "pseudo", "dafny" },
    highlight = {
        enable = true,
        disable = { "markdown", "haskell" },
    },
    indent = {
        enable = false,
        disable = { "python" },
    },
    -- yati = {
    --     enable = true,
    -- },
    autotag = {
        enable = true,
        filetypes = {
            "html",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "svelte",
        },
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
    matchup = {
        enable = true,
    },
    endwise = {
        enable = true,
    },
})
