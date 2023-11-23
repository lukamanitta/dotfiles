local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        config = function() require("plugins.ui.which-key") end,
    },
    { "numToStr/Comment.nvim" },

    -- Finder
    { "nvim-telescope/telescope.nvim",
        config = function() require("plugins.telescope") end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-lua/popup.nvim",
        },
    },

    -- File Explorer
    { "nvim-neo-tree/neo-tree.nvim",
        config = function() require("plugins.neo-tree") end,
        version = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
    },

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter",
        build = { ":TSInstall all", ":TSUpdate" }, -- Change all to a list of required ones
    },

    -- LSP
    -- mason.nvim?
    { "neovim/nvim-lspconfig" },
    { "jose-elias-alvarez/null-ls.nvim" },

    -- Completions
    { "llllvvuu/nvim-cmp",
        config = function() require("plugins.cmp") end,
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

    { "L3MON4D3/LuaSnip" },

    { "github/copilot.vim",
        config = function()
            require("plugins.copilot")
        end
    },

    -- UI
    { "rebelot/heirline.nvim" },
    { "lukas-reineke/indent-blankline.nvim",
        config = function() require("plugins.ui.indent-blankline") end,
    },
    { "rcarriga/nvim-notify",
        config = function() require("plugins.ui.notify") end,
    },
    { "j-hui/fidget.nvim",
        config = function() require("plugins.ui.fidget") end,
    },
    { "RRethy/vim-hexokinase", build = "make hexokinase" }, -- requires go?
    { "lewis6991/gitsigns.nvim",
        config = function() require("plugins.ui.gitsigns") end,
    },

    -- Colourschemes
    { "rebelot/kanagawa.nvim" },
    { "ellisonleao/gruvbox.nvim", priority = 1000,
        config = function()
            require("gruvbox").setup({
                contrast = "hard"
            })
            vim.cmd("colorscheme gruvbox")
            require("settings.theme").post_colorscheme()
        end
    },
},
{
    defaults = {
        lazy = false,
    },
    dev = {
        path = "~/code/personal",
    }
}
)
