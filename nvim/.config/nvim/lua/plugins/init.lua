local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
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

local function is_selected_colorscheme(plugin)
    return plugin.name == require("settings.theme").colorscheme
end

require("lazy").setup({
    { "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        config = function() require("plugins.ui.which-key") end,
    },

    -- Comments
    { "JoosepAlviste/nvim-ts-context-commentstring" },
    { "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup({
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            })
        end,
        lazy = false,
    },

    -- Finder
    { "nvim-telescope/telescope.nvim",
        config = function() require("plugins.telescope") end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-lua/popup.nvim",
        },
    },

    -- Explorer
    { "nvim-neo-tree/neo-tree.nvim", -- TODO: high perf impact
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
        build = { 
            ":TSInstall all", 
            ":TSUpdate" ,
        }, -- Change all to a list of required ones
    },

    -- LSP
    -- mason.nvim?
    { "neovim/nvim-lspconfig" },
    { "jose-elias-alvarez/null-ls.nvim" },

    -- Completions
    { "llllvvuu/nvim-cmp", -- Using this fork until hrs7th merges this
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

    { "L3MON4D3/LuaSnip" }, -- TODO: high perf impact

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
    { "ellisonleao/gruvbox.nvim", priority = 1000, name = "gruvbox",
        cond = is_selected_colorscheme,
        config = function()
            require("colorschemes.gruvbox")
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
