require('catppuccin').setup({
    transparency = false,
    term_colors = true,
    styles = {
        comments = 'italic',
        functions = 'italic',
        keywords = 'italic',
        strings = 'NONE',
        variables = 'NONE',
    },
    integrations = {
        treesitter = true,
        native_lsp = {
            enabled = true,
            styles = {
                errors = 'italic',
                hints = 'italic',
                warnings = 'italic',
                information = 'italic',
            },
        },
        lsp_trouble = false,
        lsp_saga = true,
        gitgutter = false,
        gitsigns = false,
        telescope = true,
        nvimtree = {
            enabled = true,
            show_root = true,
        },
        which_key = true,
        indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
        },
        dashboard = false,
        neogit = false,
        vim_sneak = false,
        fern = false,
        barbar = false,
        bufferline = true,
        markdown = false,
    },
})