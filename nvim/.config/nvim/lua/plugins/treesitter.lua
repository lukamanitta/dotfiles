require('nvim-treesitter.configs').setup({
    -- ensure_installed = 'maintained', -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    disable = { 'markdown' },

    highlight = {
        enable = true,
        disable = { 'markdown' },
    },
    indent = {
        enable = true,
        disable = { 'python' },
    },
    autotag = {
        enable = true,
        filetypes = { 'html', 'javascript', 'javascriptreact', 'typescriptreact' },
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
    matchup = {
        enable = true,
        disable = {},
    },
})
