local highlight = {
    "Whitespace",
}

require("ibl").setup {
    indent = { 
        highlight = highlight, 
        char = "▏", --  "┆", "┊", "", "▏", "|"
    },
    whitespace = {
        highlight = highlight,
        remove_blankline_trail = false,
    },
    scope = { enabled = false },
}

-- require("plugins.ui.indent-blankline.custom_hl")
