-- Auto-installer packer.nvim if not installed
local cmd, fn = vim.cmd, vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    cmd("packadd packer.nvim")
end

return require("packer").startup({
    function()
        use({

            -- Packer can manage itself as an optional plugin
            "wbthomason/packer.nvim",

            -- File explorer
            {
                "nvim-neo-tree/neo-tree.nvim",
                cmd = "Neotree",
                config = function()
                    require("plugins.neotree")
                end,
                requires = {
                    "nvim-lua/plenary.nvim",
                    "kyazdani42/nvim-web-devicons",
                    "MunifTanjim/nui.nvim",
                },
            },

            -- Finder
            {
                "nvim-telescope/telescope.nvim",
                -- cmd = { 'Telescope' },
                config = function()
                    require("plugins.telescope")
                end,
                requires = {
                    "nvim-lua/plenary.nvim",
                    "nvim-lua/popup.nvim",
                },
            },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                run = "make",
                require = { "nvim-telescope/telescope.nvim" },
            },

            -- Objects and Movements
            {
                "numToStr/Comment.nvim",
                config = function()
                    require("plugins.comment")
                end,
            },
            {
                "lukas-reineke/indent-blankline.nvim",
                config = function()
                    require("plugins.indent_blankline")
                end,
            },
            { "chun-yang/auto-pairs" },
            { "tpope/vim-surround" },
            { "chaoren/vim-wordmotion" },
            { "andymass/vim-matchup" },
            {
                "phaazon/hop.nvim",
                branch = "v1",
                config = function()
                    require("plugins.hop")
                end,
            },

            -- Lsp & Completions
            { "williamboman/nvim-lsp-installer" },
            { "neovim/nvim-lspconfig" },
            {
                "folke/trouble.nvim",
                config = function()
                    require("lsp.trouble")
                end,
            },
            { "tami5/lspsaga.nvim" },
            {
                "nvim-treesitter/playground",
                cmd = { "TSPlaygroundToggle" },
            },
            {
                "nvim-treesitter/nvim-treesitter",
                run = { ":TSInstall maintained", ":TSUpdate" },
                config = function()
                    require("plugins.treesitter")
                end,
                requires = {
                    "windwp/nvim-ts-autotag",
                    "RRethy/nvim-treesitter-endwise",
                    "JoosepAlviste/nvim-ts-context-commentstring",
                    "yioneko/nvim-yati",
                },
            },
            {
                "jose-elias-alvarez/null-ls.nvim",
                config = function()
                    require("plugins.null-ls")
                end,
            },
            {
                "L3MON4D3/luasnip",
                config = function()
                    require("plugins.luasnip")
                end,
            },
            { "rafamadriz/friendly-snippets" },
            {
                "hrsh7th/nvim-cmp",
                config = function()
                    require("plugins.cmp")
                end,
                requires = {
                    "hrsh7th/cmp-nvim-lsp",
                    "hrsh7th/cmp-nvim-lsp-signature-help",
                    "hrsh7th/cmp-nvim-lua",
                    "hrsh7th/cmp-buffer",
                    "hrsh7th/cmp-path",
                    "hrsh7th/cmp-omni",
                    -- {
                    --     'quangnguyen30192/cmp-nvim-ultisnips',
                    --     requires = 'SirVer/ultisnips',
                    -- },
                    {
                        "saadparwaiz1/cmp_luasnip",
                        requires = "L3MON4D3/luasnip",
                    },
                    "f3fora/cmp-spell",
                    { "tzachar/cmp-tabnine", run = "./install.sh" },
                    "kdheepak/cmp-latex-symbols",
                    "davidsierradz/cmp-conventionalcommits",
                },
            },
            { "github/copilot.vim" },

            -- Language specific styling
            { "styled-components/vim-styled-components" },
            { "Vimjas/vim-python-pep8-indent" },
            { "benknoble/vim-dafny" },

            -- UI
            -- ryanoasis/vim-devicons'
            { "kyazdani42/nvim-web-devicons" },
            { "nvim-lualine/lualine.nvim" },
            {
                "noib3/nvim-cokeline",
                -- Config is sourced after colourscheme is loaded, see plugins.colorschemes/
            },
            {
                "rcarriga/nvim-notify",
                config = function()
                    require("plugins.notify")
                end,
            },
            {
                "norcalli/nvim-colorizer.lua",
                config = function()
                    require("plugins.colorizer")
                end,
            },
            {
                "lukamanitta/nvim-cursorword",
                config = function()
                    require("plugins.cursorword")
                end,
            },
            {
                "SmiteshP/nvim-gps",
                config = function()
                    require("plugins.gps")
                end,
            },
            {
                "folke/which-key.nvim",
                config = function()
                    require("plugins.which-key")
                end,
            },
            {
                "lewis6991/gitsigns.nvim",
                config = function()
                    require("plugins.gitsigns")
                end,
            },
            {
                "j-hui/fidget.nvim",
                config = function()
                    require("plugins.fidget")
                end,
            },

            -- Colourschemes
            -- {
            --     'catppuccin/nvim',
            --     config = function()
            --         require('plugins.colorschemes.catppuccin')
            --     end,
            -- },
            { "folke/tokyonight.nvim" },
            { "Shatur/neovim-ayu" },
            { "rebelot/kanagawa.nvim" },
            { "EdenEast/nightfox.nvim" },

            -- Other
            {
                "kdheepak/lazygit.nvim",
                branch = "main",
                cmd = "LazyGit",
                config = function()
                    require("plugins.lazygit")
                end,
            },
            {
                "voldikss/vim-floaterm",
                cmd = { "FloatermNew", "FloatermToggle" },
                config = function()
                    vim.cmd("hi link FloatermBorder Normal")
                end,
            },
            {
                "AckslD/nvim-neoclip.lua",
                config = function()
                    require("plugins.neoclip")
                end,
            },
            {
                "tpope/vim-fugitive",
                cmd = {
                    "Git",
                    "Gedit",
                    "Gsplit",
                    "Gdiffsplitt",
                    "Gread",
                    "Gwrite",
                    "Ggrep",
                    "GMove",
                    "GRename",
                    "GDelete",
                    "GRemove",
                    "GBrowse",
                },
            },
            { "famiu/nvim-reload", cmd = { "Reload", "Restart" } },
            { "lewis6991/impatient.nvim" },
            { "tpope/vim-repeat" },
            {
                "mtth/scratch.vim",
                config = function()
                    require("plugins.scratch")
                end,
            },

            -- Notes
            {
                "preservim/vim-markdown",
                ft = { "markdown" },
                config = function()
                    require("plugins.markdown")
                end,
            },
            {
                "iamcco/markdown-preview.nvim",
                run = "cd app && yarn install",
                config = function()
                    require("plugins.markdown-preview")
                end,
            },
            {
                "KeitaNakamura/tex-conceal.vim",
                ft = { "markdown" },
                config = function()
                    require("plugins.tex-conceal")
                end,
            },
            {
                "Furkanzmc/zettelkasten.nvim",
                config = function()
                    require("plugins.zettelkasten")
                end,
            },
            {
                "mickael-menu/zk-nvim",
                -- config = function()
                --     require('plugins.zk')
                -- end,
            },
            -- {
            --     'jakewvincent/mkdnflow.nvim',
            --     ft = { 'markdown' },
            --     config = function()
            --         require('plugins.mkdnflow')
            --     end,
            -- },
            {
                "Pocco81/TrueZen.nvim",
                ft = { "markdown" },
                config = function()
                    require("plugins.truezen")
                end,
            },
            {
                "dhruvasagar/vim-table-mode",
                config = function()
                    vim.g.table_mode_map_prefix = "<leader>tm"
                end,
            },

            -- My Plugins
            { "lukamanitta/naturally.nvim" },
        })
    end,
    config = {
        display = {
            open_fn = require("packer.util").float,
        },
        profile = {
            enable = true,
            threshold = 1,
        },
    },
})
