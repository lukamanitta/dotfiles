require("dressing").setup({
    input = {
        enabled = true,
        default_prompt = "Input: ",
        prompt_align = "left",
        insert_only = false,
        start_in_insert = true,
        anchor = "SW",
        border = "rounded",
        relative = "cursor", -- cursor | editor | win (editor & win are centered)
        prefer_width = 40, -- Can be integer or float (for %)
        width = nil,
        -- List of mixed types. {20, 0.2} means "the greater of 20 columns or 20% of total"
        max_width = { 140, 0.9 },
        min_width = { 20, 0.2 },

        -- Window transparency (0-100)
        winblend = 10,
        -- Change default highlight groups (see :help winhl)
        winhighlight = "",

        -- Set to `false` to disable
        mappings = {
            n = {
                ["<Esc>"] = "Close",
                ["<CR>"] = "Confirm",
            },
            i = {
                ["<C-c>"] = "Close",
                ["<CR>"] = "Confirm",
                ["<Up>"] = "HistoryPrev",
                ["<Down>"] = "HistoryNext",
            },
        },

        override = function(conf)
            -- This is the config that will be passed to nvim_open_win.
            return conf
        end,
    },
    select = {
        enabled = true,
        backend = { "telescope", "builtin" }, -- Priority list of implementations
        trim_prompt = true, -- Trim trailing ":"
        telescope = nil, -- Options table for telescope picker

        -- Options for built-in selector
        builtin = {
            anchor = "SW",
            border = "rounded",
            relative = "cursor",

            winblend = 10,
            winhighlight = "",

            width = nil,
            max_width = { 140, 0.8 },
            min_width = { 40, 0.2 },
            height = nil,
            max_height = 0.9,
            min_height = { 10, 0.2 },

            mappings = {
                ["<Esc>"] = "Close",
                ["<C-c>"] = "Close",
                ["<CR>"] = "Confirm",
            },

            override = function(conf)
                return conf
            end,
        },
    },
})
