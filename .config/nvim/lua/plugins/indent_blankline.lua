require('indent_blankline').setup({
    buftype_exclude = { 'terminal' },
    filetype_exclude = { 'packer', 'lspinfo', 'Trouble' },
    show_current_context = true,
    use_treesitter = true,
})
