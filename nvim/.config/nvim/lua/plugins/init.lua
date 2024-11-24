local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local function is_selected_colorscheme(plugin)
    return plugin.name == require("settings.theme").colorscheme
end

require("lazy").setup({
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        config = function()
            require("plugins.ui.which-key")
        end,
    },

    -- Motions & Objects
    {
        "smoka7/hop.nvim",
        version = "*",
        config = function()
            require("plugins.hop")
        end,
    },

    -- Comments
    { "JoosepAlviste/nvim-ts-context-commentstring" },
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup({
                pre_hook = require(
                    "ts_context_commentstring.integrations.comment_nvim"
                ).create_pre_hook(),
            })
        end,
        lazy = false,
    },

    -- Finder
    {
        "nvim-telescope/telescope.nvim",
        config = function()
            require("plugins.telescope")
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-lua/popup.nvim",
        },
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
    },

    -- Explorer
    {
        "nvim-neo-tree/neo-tree.nvim", -- TODO: high perf impact
        config = function()
            require("plugins.neo-tree")
        end,
        version = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
    },

    -- LazyGit
    {
        "kdheepak/lazygit.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        keys = {
            { "<LEADER>lg", "<CMD>LazyGit<CR>", desc = "LazyGit" }
        }
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = {
            ":TSInstall ruby javascript typescript tsx html css scss json yaml markdown bash lua python rust svelte",
            ":TSUpdate",
        }, -- Change all to a list of required ones
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = {
                    enable = true,
                },
            })
            vim.treesitter.language.register("markdown", "mdx")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("plugins.treesitter-context")
        end,
    },

    -- LSP & Formatting
    { "neovim/nvim-lspconfig" },
    { "jose-elias-alvarez/null-ls.nvim" },
    {
        "stevearc/conform.nvim",
        config = function()
            require("plugins.conform")
        end,
    },

    -- Completions
    {
        "llllvvuu/nvim-cmp", -- Using this fork until hrs7th merges this
        config = function()
            require("plugins.cmp")
        end,
        branch = "feat/above",
    },
    -- { "hrsh7th/cmp-nvim-lsp", dependencies = "llllvvuu/nvim-cmp" },
    -- { "hrsh7th/cmp-nvim-lsp-signature-help", dependencies = "llllvvuu/nvim-cmp" },
    -- { "hrsh7th/cmp-nvim-lua", dependencies = "llllvvuu/nvim-cmp" },
    -- { "hrsh7th/cmp-buffer", dependencies = "llllvvuu/nvim-cmp" },
    -- { "hrsh7th/cmp-path", dependencies = "llllvvuu/nvim-cmp" },

    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lsp-signature-help" },
    { "hrsh7th/cmp-nvim-lua" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },

    { "L3MON4D3/LuaSnip",                   build = "make install_jsregexp" }, -- TODO: high perf impact

    {
        "github/copilot.vim",
        config = function()
            require("plugins.copilot")
        end,
    },

    -- UI
    {
        "rebelot/heirline.nvim",
        config = function()
            require("plugins.ui.heirline")
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("plugins.ui.indent-blankline")
        end,
    },
    {
        "rcarriga/nvim-notify",
        config = function()
            require("plugins.ui.notify")
        end,
    },
    {
        "j-hui/fidget.nvim",
        config = function()
            require("plugins.ui.fidget")
        end,
    },
    { "RRethy/vim-hexokinase", build = "make hexokinase" }, -- requires go
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("plugins.ui.gitsigns")
        end,
    },
    {
        "DaikyXendo/nvim-material-icon", -- TODO: maybe high perf impact? seems large for what it is
        config = function()
            require("plugins.ui.nvim-material-icon")
        end,
    },

    -- Colourschemes
    {
        "rebelot/kanagawa.nvim",
        priority = 999,
        name = "kanagawa",
        cond = is_selected_colorscheme,
        config = function()
            require("settings.theme").pre_colorscheme_actions()
            require("colorschemes.kanagawa")
            require("settings.theme").post_colorscheme_actions()
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        priority = 999,
        name = "gruvbox",
        cond = is_selected_colorscheme,
        config = function()
            require("settings.theme").pre_colorscheme_actions()
            require("colorschemes.gruvbox")
            require("settings.theme").post_colorscheme_actions()
        end,
    },

    -- Mini
    {
        "echasnovski/mini.nvim",
        version = false,
        config = function()
            require("mini.move").setup()
            require("mini.surround").setup({
                mappings = {
                    delete = "ds",  -- Delete surrounding
                    replace = "cs", -- Replace surrounding
                },
            })
        end,
    },
}, {
    defaults = {
        lazy = false,
    },
    dev = {
        path = "~/code/personal",
    },
})
