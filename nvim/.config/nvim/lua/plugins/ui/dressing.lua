local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg

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
        winblend = 0,
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
        backend = { "telescope", "nui", "builtin" }, -- Priority list of implementations
        trim_prompt = true, -- Trim trailing ":"
        telescope = nil, -- Options table for telescope picker

        -- Options for nui Menu
        nui = {
            position = "50%",
            size = nil,
            relative = "editor",
            border = {
                style = "rounded",
            },
            buf_options = {
                swapfile = false,
                filetype = "DressingSelect",
            },
            win_options = {
                winblend = 0,
            },
            max_width = 80,
            max_height = 40,
            min_width = 40,
            min_height = 10,
        },

        -- Options for built-in selector
        builtin = {
            anchor = "SW",
            border = "rounded",
            relative = "cursor",

            winblend = 0,
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

vim.cmd(
    "hi FloatBorder guibg="
        .. get_hi_group_bg("Normal")
        .. " guifg="
        .. get_hi_group_fg("Conditional")
)
vim.cmd("hi NormalFloat guibg=" .. get_hi_group_bg("Normal"))
-- vim.cmd("hi FloatTitle guibg=" .. get_hi_group_bg("Normal"))
