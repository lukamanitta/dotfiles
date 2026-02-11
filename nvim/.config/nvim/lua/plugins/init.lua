-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

local function is_selected_colourscheme(plugin)
    return plugin.name == vim.g.colourscheme
end

require("lazy").setup({
    spec = {
        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            init = function()
                vim.o.timeout = true
                vim.o.timeoutlen = 3000
            end,
        },

        -- Motions & Objects
        {
            "wsdjeg/hop.nvim",
            config = function()
                require("plugins.hop")
            end,
        },
        { "nvim-mini/mini.move" },
        {
            "nvim-mini/mini.surround",
            opts = {
                mappings = {
                    delete = "ds",
                    replace = "cs",
                },
            },
        },

        -- Comments
        {
            "JoosepAlviste/nvim-ts-context-commentstring",
            config = function()
                require("plugins.nvim-ts-context-commentstring")
            end,
        },

        -- Finder
        {
            "nvim-telescope/telescope.nvim",
            version = "*",
            config = function()
                require("plugins.telescope")
            end,
            dependencies = {
                "nvim-lua/plenary.nvim",
                { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            },
        },

        -- Explorer
        {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v3.x",
            config = function()
                require("plugins.neo-tree")
            end,
            dependencies = {
                "nvim-lua/plenary.nvim",
                "MunifTanjim/nui.nvim",
                "nvim-tree/nvim-web-devicons",
            },
        },
        {
            "antosha417/nvim-lsp-file-operations",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
            },
        },
        {
            "otavioschwanck/arrow.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            opts = {
                show_icons = true,
                leader_key = ";",
                buffer_leader_key = "m",
                window = { border = "none" },
                per_buffer_config = {
                    lines = 6,
                },
            },
        },

        -- Treesitter
        {
            "nvim-treesitter/nvim-treesitter",
            branch = "main",
            lazy = false,
            build = ":TSUpdate",
            config = function()
                require("plugins.nvim-treesitter")
                vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Normal" })
            end,
            dependencies = {
                {
                    "nvim-treesitter/nvim-treesitter-context",
                    opts = {
                        max_line = 4,
                        multiline_threshold = 2,
                        separator = "·",
                    },
                },
            },
        },

        -- LSP & Formatting
        { "neovim/nvim-lspconfig", lazy = false },
        {
            "mason-org/mason-lspconfig.nvim",
            dependencies = {
                { "mason-org/mason.nvim", opts = {} },
                "neovim/nvim-lspconfig",
            },
            opts = {
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    "svelte",
                    "ts_ls",
                    "clangd",
                    "cmake",
                },
            },
        },
        {
            "stevearc/conform.nvim",
            config = function()
                require("plugins.conform")
            end,
        },

        -- Debugging
        {
            "mfussenegger/nvim-dap",
            lazy = true,
            keys = require("plugins.debugging.keybinds"),
            config = function()
                require("plugins.debugging.dap")
            end,
        },
        {
            "rcarriga/nvim-dap-ui",
            lazy = true,
            dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
            config = function()
                require("plugins.debugging.dap-ui")
            end,
        },
        {
            "theHamsta/nvim-dap-virtual-text",
            lazy = true,
            dependencies = { "mfussenegger/nvim-dap" },
            config = function()
                require("plugins.debugging.dap-virtual-text")
            end,
        },

        -- Completions
        {
            "saghen/blink.cmp",
            version = "1.*",
            dependencies = {
                "rafamadriz/friendly-snippets",
                "Kaiser-Yang/blink-cmp-avante",
            },
            config = function()
                require("plugins.blink-cmp")
            end,
        },
        -- {
        --     "github/copilot.vim",
        --     config = function()
        --         require("plugins.copilot")
        --     end,
        -- },
        -- {
        --     "yetone/avante.nvim",
        --     build = "make",
        --     event = "VeryLazy",
        --     version = false,
        --     dependencies = {
        --         "nvim-lua/plenary.nvim",
        --         "MunifTanjim/nui.nvim",
        --         "zbirenbaum/nvim-web-devicons",
        --     },
        --     opts = {
        --         provider = "gemini",
        --         acp_providers = {
        --             ["gemini-cli"] = {
        --                 command = "gemini",
        --                 args = { "--experimental-acp" },
        --                 env = {
        --                     NODE_NO_WARNINGS = "1",
        --                     GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
        --                 },
        --             },
        --         },
        --     },
        -- },

        -- UI
        {
            "lukas-reineke/indent-blankline.nvim",
            main = "ibl",
            opts = {
                indent = { char = "▏" },
                scope = { enabled = false },
            },
        },
        {
            "rcarriga/nvim-notify",
            config = function()
                require("notify").setup({
                    fps = 60,
                    timeout = 3000,
                })
                vim.notify = require("notify")
            end,
        },
        { "j-hui/fidget.nvim", opts = {} },
        { "RRethy/vim-hexokinase", build = "make hexokinase" }, -- requires go
        { "nvim-mini/mini.diff", opts = {} },
        { "mawkler/hml.nvim", opts = {} },

        -- Colourschemes
        {
            "kdheepak/monochrome.nvim",
            name = "monochrome",
            priority = 1000,
            cond = is_selected_colourscheme,
            config = function()
                vim.cmd.colorscheme("monochrome")
            end,
        },
        {
            "rebelot/kanagawa.nvim",
            name = "kanagawa",
            priority = 1000,
            cond = is_selected_colourscheme,
            config = function()
                vim.cmd.colorscheme("kanagawa")
            end,
        },
        {
            "ellisonleao/gruvbox.nvim",
            name = "gruvbox",
            priority = 1000,
            cond = is_selected_colourscheme,
            config = function()
                require("plugins.colourschemes.gruvbox")
            end,
        },
        {
            "catppuccin/nvim",
            name = "catppuccin",
            priority = 1000,
            cond = is_selected_colourscheme,
            config = function()
                vim.cmd.colorscheme("catppuccin")
            end,
        },
        {
            "zenbones-theme/zenbones.nvim",
            name = "zenwritten",
            dependencies = { "rktjmp/lush.nvim" },
            priority = 1000,
            cond = is_selected_colourscheme,
            config = function()
                require("plugins.colourschemes.zenwritten")
            end,
        },
    },
})
