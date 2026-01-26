require("blink.cmp").setup({
    -- keymap = { preset = "default" },
    sources = {
        default = {
            "avante",
            "lsp",
            "path",
            "snippets",
            "buffer",
        },
        providers = {
            avante = {
                module = "blink-cmp-avante",
                name = "Avante",
            },
        },
    },
    keymap = {
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Esc>"] = { "cancel", "fallback" },

        ["<Tab>"] = {
            function(cmp)
                return cmp.select_next()
            end,
            "snippet_forward",
            "fallback",
        },
        ["<S-Tab>"] = {
            function(cmp)
                return cmp.select_prev()
            end,
            "snippet_backward",
            "fallback",
        },

        ["<Down>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "snippet_forward", "fallback" },
        ["<C-p>"] = { "snippet_backward", "fallback" },
        ["<C-up>"] = { "scroll_documentation_up", "fallback" },
        ["<C-down>"] = { "scroll_documentation_down", "fallback" },
    },
    completion = {
        menu = {
            max_height = 10,
            direction_priority = { "n", "s" },
        },
        list = {
            selection = {
                auto_insert = true,
                preselect = false,
            },
        },
        documentation = {
            window = {
                direction_priority = {
                    menu_north = { "e", "w", "n", "s" },
                    menu_south = { "e", "w", "n", "s" },
                },
            },
        },
    },
})
