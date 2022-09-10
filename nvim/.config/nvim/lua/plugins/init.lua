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

local local_plug_dir = function(plug_name)
    return "~/projects/nvim-plugins/" .. plug_name
end

return require("packer").startup({
    function()
        use({

            -- Packer can manage itself as an optional plugin
            "wbthomason/packer.nvim",

            -- Local Plugins
            {
                local_plug_dir("runvim"),
                config = function()
                    require("runvim").setup()
                end,
            },
            { local_plug_dir("naturally.nvim") },

            -- File explorer
            {
                "nvim-neo-tree/neo-tree.nvim",
                branch = "v2.x",
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
            { "jiangmiao/auto-pairs" },
            { "tpope/vim-surround" },
            { "chaoren/vim-wordmotion" },
            { "andymass/vim-matchup" },
            {
                "phaazon/hop.nvim",
                branch = "v2",
                config = function()
                    require("plugins.hop")
                end,
            },

            -- Treesitter
            {
                "nvim-treesitter/playground",
                cmd = { "TSPlaygroundToggle" },
            },
            {
                "nvim-treesitter/nvim-treesitter",
                run = { ":TSInstall all", ":TSUpdate" },
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

            -- Lsp & Completions
            {
                "williamboman/mason.nvim",
                config = function()
                    require("mason").setup({
                        border = "rounded",
                    })
                end,
            },
            {
                "williamboman/mason-lspconfig.nvim",
                config = function()
                    require("mason-lspconfig").setup({
                        ensure_installed = {
                            "sumneko_lua",
                            "vimls",
                            "tsserver",
                        },
                    })
                end,
                after = "mason.nvim",
            },
            {
                "neovim/nvim-lspconfig",
                after = "mason-lspconfig.nvim",
            },
            -- TODO: remove this
            { "williamboman/nvim-lsp-installer" },
            {
                "folke/trouble.nvim",
                config = function()
                    require("lsp.trouble")
                end,
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
                requires = {
                    "rafamadriz/friendly-snippets",
                },
            },
            {
                "danymat/neogen",
                config = function()
                    require("neogen").setup({ snippet_engine = "luasnip" })
                end,
                requires = {
                    "L3MON4D3/luasnip",
                },
            },
            {
                "hrsh7th/nvim-cmp",
                config = function()
                    require("plugins.cmp")
                end,
                requires = {
                    "hrsh7th/cmp-nvim-lsp",
                    "hrsh7th/cmp-nvim-lsp-signature-help",
                    "hrsh7th/cmp-nvim-lua",
                    "folke/lua-dev.nvim",
                    "hrsh7th/cmp-buffer",
                    "hrsh7th/cmp-path",
                    "hrsh7th/cmp-omni",
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
            { "kyazdani42/nvim-web-devicons" },
            { "nvim-lualine/lualine.nvim" },
            { "noib3/nvim-cokeline" },
            -- {
            --     "rebelot/heirline.nvim",
            --     config = function()
            --         require("plugins.statusline.heirline")
            --     end,
            -- },
            -- {
            --     "SmiteshP/nvim-navic",
            --     config = function()
            --         require("plugins.statusline.navic")
            --     end,
            -- },
            {
                "lukas-reineke/indent-blankline.nvim",
                config = function()
                    require("plugins.ui.indent_blankline")
                end,
            },
            {
                "rcarriga/nvim-notify",
                config = function()
                    require("plugins.ui.notify")
                end,
            },
            {
                "RRethy/vim-hexokinase",
                run = "make hexokinase",
                config = function()
                    require("plugins.ui.hexokinase")
                end,
            },
            {
                "xiyaowong/nvim-cursorword",
                config = function()
                    require("plugins.ui.cursorword")
                end,
            },
            { -- TODO: replace with navic
                "SmiteshP/nvim-gps",
                config = function()
                    require("plugins.statusline.gps")
                end,
            },
            {
                "folke/which-key.nvim",
                config = function()
                    require("plugins.ui.which-key")
                end,
            },
            {
                "lewis6991/gitsigns.nvim",
                config = function()
                    require("plugins.ui.gitsigns")
                end,
            },
            {
                "j-hui/fidget.nvim",
                config = function()
                    require("plugins.ui.fidget")
                end,
            },
            {
                "stevearc/dressing.nvim",
                config = function()
                    require("plugins.ui.dressing")
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

            -- Meta
            { "famiu/nvim-reload", cmd = { "Reload", "Restart" } },
            { "lewis6991/impatient.nvim" },

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
            { "tpope/vim-repeat" },
            {
                "folke/todo-comments.nvim",
                requires = "nvim-lua/plenary.nvim",
                config = function()
                    require("plugins.todo")
                end,
            },

            -- Markdown
            {
                "preservim/vim-markdown",
                requires = "godlygeek/tabular",
                ft = { "markdown" },
                config = function()
                    require("plugins.markdown.vim-markdown")
                end,
            },
            {
                "iamcco/markdown-preview.nvim",
                run = "cd app && yarn install",
                config = function()
                    require("plugins.markdown.markdown-preview")
                end,
            },
            {
                "KeitaNakamura/tex-conceal.vim",
                ft = { "markdown", "pseudo" },
                config = function()
                    require("plugins.markdown.tex-conceal")
                end,
            },
            {
                "mickael-menu/zk-nvim",
                config = function()
                    require("plugins.markdown.zk")
                end,
            },
            {
                "jakewvincent/mkdnflow.nvim",
                ft = { "markdown" },
                rocks = "luautf8",
                config = function()
                    require("plugins.markdown.mkdnflow")
                end,
            },
            -- {
            --     "Pocco81/TrueZen.nvim",
            --     ft = { "markdown" },
            --     config = function()
            --         require("plugins.ui.truezen")
            --     end,
            -- },
            {
                "dhruvasagar/vim-table-mode",
                config = function()
                    vim.g.table_mode_map_prefix = "<leader>tm"
                    vim.g.table_mode_add_formula_map = "<leader>tmf"
                    vim.g.table_mode_corner = "|"
                    vim.g.table_mode_corner_corner = "|"
                end,
            },
            -- -- Images
            -- {
            --     "ekickx/clipboard-image.nvim",
            --     config = function()
            --         require("plugins.markdown.images.clipboard-image")
            --     end,
            --     requires = { "edluffy/hologram.nvim" },
            -- },
            -- {
            --     "edluffy/hologram.nvim",
            --     config = function()
            --         require("plugins.markdown.images.hologram")
            --     end,
            --     requires = { "ekickx/clipboard-image.nvim" },
            -- },
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
        max_jobs = 50,
    },
})
