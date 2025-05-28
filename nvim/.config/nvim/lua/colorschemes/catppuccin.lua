require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = {
        light = "latte",
        dark = "mocha",
    },
    dim_inactive = {
        enabled = true,    -- dims the background color of inactive window
        shade = "dark",    -- can be set to 'dark' or 'light'
        percentage = 0.08, -- percentage of the shade to apply to the inactive window
    },
    integrations = {
        cmp = true,
        gitsigns = true,
        telescope = false,
        treesitter = true,
        treesitter_context = true,
        nvimtree = true,
        notify = true,
        fidget = true,
        hop = true,
        mini = true,
        neotree = false, -- Breaks my styling if enabled
        copilot_vim = true,
        which_key = true,
        markdown = true,
    },
})

vim.cmd("hi! TreesitterContext guibg=#1e1e2e guifg=#cdd6f4")

vim.cmd("colorscheme catppuccin")
