local opts = {
    -- Compiled file's destination location
    compile_path = vim.fn.stdpath("cache") .. "/nightfox",
    compile_file_suffix = "_compiled", -- Compiled file suffix
    transparent = false, -- Disable setting background
    terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
    dim_inactive = false, -- Non focused panes set to alternative background
    styles = { -- Style to be applied to different syntax groups
        comments = "NONE", -- Value is any valid attr-list value `:help attr-list`
        functions = "NONE",
        keywords = "NONE",
        numbers = "NONE",
        strings = "NONE",
        types = "NONE",
        variables = "NONE",
    },
    inverse = { -- Inverse highlight for different types
        match_paren = false,
        visual = false,
        search = false,
    },
    modules = { -- List of various plugins and additional options
        barbar = false,
        cmp = true,
        dashboard = false,
        diagnostics = false,
        fern = false,
        fidget = true,
        gitgutter = false,
        gitsigns = true,
        glyph_pallet = false,
        hop = true,
        illuminate = false,
        lightspeed = false,
        lsp_saga = false,
        lsp_trouble = true,
        modes = true,
        native_lsp = true,
        neogit = false,
        neotree = true,
        nvimtree = false,
        pounce = false,
        sneak = false,
        symbol_outline = false,
        telescope = true,
        treesitter = true,
        tsrainbow = false,
        whichkey = true,
    },
}

return opts
