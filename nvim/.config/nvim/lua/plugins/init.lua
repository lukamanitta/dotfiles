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
    { "folke/which-key.nvim" },

    -- Finder
    { "nvim-telescope/telescope.nvim"
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-lua/popup.nvim",
        },
    },

    -- File Explorer
    { "nvim-neo-tree/neo-tree.nvim"
        version = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
    }

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter",
        build = { ":TSInstall all", ":TSUpdate" }, -- Change all to a list of required ones
    }

    -- LSP
    -- mason.nvim?
    { "neovim/nvim-lspconfig" }
    { "jose-elias-alvarez/null-ls.nvim" }

    -- Completions
    { "hrsh7th/nvim-cmp", as = "cmp" },
    { "hrsh7th/cmp-nvim-lsp", dependencies = "cmp" },
    { "hrsh7th/cmp-nvim-lsp-signature-help", dependencies = "cmp" },
    { "hrsh7th/cmp-nvim-lua", dependencies = "cmp" },
    { "hrsh7th/cmp-buffer", dependencies = "cmp" },
    { "hrsh7th/cmp-path", dependencies = "cmp" },

    { "github/copilot.vim" },

    -- UI
    { "rebelot/heirline.nvim" },
    { "luka-reineke/indent-blankline.nvim" },
    { "rcarriga/nvim-notify" },
    { "j-hui/fidget.nvim" },
    { "RRethy/vim-hexokinase", build = "make hexokinase" }, -- requires go?
    { "lewis6991/gitsigns.nvim" },

    -- Colourschemes
    { "rebelot/kanagawa.nvim" },
    { "ellisonleao/gruvbox.nvim" },
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
