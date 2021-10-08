require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages

    highlight= {
          enable= true
    },
    indent = {
        enable = true,
    },
    autotag = {
        enable = true,
        filetypes = { 'html', 'javascript', 'javascriptreact', 'typescriptreact' }
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
    matchup = {
        enable = true,
        disable = {},
    },
}
