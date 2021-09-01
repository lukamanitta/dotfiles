lua << EOF
local catppuccino = require("catppuccino")

-- configure it
catppuccino.setup(
    {
        colorscheme = "dark_catppuccino",
        transparency = false,
        term_colors = false,
        styles = {
            comments = "italic",
            functions = "italic",
            keywords = "italic",
            strings = "NONE",
            variables = "NONE",
        },
        integrations = {
            treesitter = true,
            native_lsp = {
                enabled = false,
                styles = {
                    errors = "italic",
                    hints = "italic",
                    warnings = "italic",
                    information = "italic"
                }
            },
            lsp_trouble = false,
            lsp_saga = false,
            gitgutter = false,
            gitsigns = false,
            telescope = true,
            nvimtree = {
                enabled = true,
                show_root = false,
            },
            which_key = false,
            indent_blankline = false,
            dashboard = false,
            neogit = false,
            vim_sneak = false,
            fern = false,
            barbar = false,
            bufferline = false,
            markdown = false,
        }
    }
)
EOF

