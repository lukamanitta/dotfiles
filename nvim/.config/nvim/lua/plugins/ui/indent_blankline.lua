require("indent_blankline").setup({
    char = "┊", -- "┆", "┊", ""
    buftype_exclude = { "terminal" },
    filetype_exclude = {
        "packer",
        "lspinfo",
        "Trouble",
        "lsp-installer",
        "neo-tree",
        "neo-tree-popup",
        "mason",
    },
    show_current_context = true,
    show_current_context_start = false,
    use_treesitter = true,
})
