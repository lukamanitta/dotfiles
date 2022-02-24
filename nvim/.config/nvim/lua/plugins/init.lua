-- Auto-installer packer.nvim if not installed
local cmd, fn = vim.cmd, vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path,
    })
    cmd('packadd packer.nvim')
end

return require('packer').startup({
    function()
        use({

            -- Packer can manage itself as an optional plugin
            'wbthomason/packer.nvim',

            -- File explorer
            {
                'kyazdani42/nvim-tree.lua',
                commit = 'd8bf1adcdcc6a8a66c3dce5c29a4ef06e21dc844',
                cmd = { 'NvimTreeToggle' },
                config = function()
                    require('plugins.nvimtree')
                end,
            },

            -- Finder
            {
                'nvim-telescope/telescope.nvim',
                -- cmd = { 'Telescope' },
                config = function()
                    require('plugins.telescope')
                end,
                requires = {
                    'nvim-lua/plenary.nvim',
                    'nvim-lua/popup.nvim',
                },
            },
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                run = 'make',
                require = { 'nvim-telescope /telescope.nvim' },
            },

            -- Objects and Movements
            {
                'terrortylor/nvim-comment',
                config = function()
                    require('plugins.nvim_comment')
                end,
            },
            {
                'lukas-reineke/indent-blankline.nvim',
                config = function()
                    require('plugins.indent_blankline')
                end,
            },
            { 'chun-yang/auto-pairs' },
            { 'tpope/vim-surround' },
            { 'bkad/CamelCaseMotion' },
            { 'andymass/vim-matchup' },
            {
                'phaazon/hop.nvim',
                branch = 'v1',
                config = function()
                    require('plugins.hop')
                end,
            },

            -- Lsp & Completions
            { 'williamboman/nvim-lsp-installer' },
            { 'neovim/nvim-lspconfig' },
            {
                'folke/trouble.nvim',
                config = function()
                    require('lsp.trouble')
                end,
            },
            { 'tami5/lspsaga.nvim' },
            {
                'nvim-treesitter/playground',
                cmd = { 'TSPlaygroundToggle' },
            },
            {
                'nvim-treesitter/nvim-treesitter',
                run = { ':TSInstall maintained', ':TSUpdate' },
                config = function()
                    require('plugins.treesitter')
                end,
                requires = {
                    'windwp/nvim-ts-autotag',
                    'RRethy/nvim-treesitter-endwise',
                    'JoosepAlviste/nvim-ts-context-commentstring',
                },
            },
            {
                'jose-elias-alvarez/null-ls.nvim',
                config = function()
                    require('plugins.null-ls')
                end,
            },
            {
                'hrsh7th/nvim-cmp',
                config = function()
                    require('plugins.cmp')
                end,
                requires = {
                    'hrsh7th/cmp-nvim-lsp',
                    'hrsh7th/cmp-buffer',
                    'hrsh7th/cmp-path',
                    'SirVer/ultisnips',
                    'quangnguyen30192/cmp-nvim-ultisnips',
                    { 'tzachar/cmp-tabnine', run = './install.sh' },
                },
            },
            { 'github/copilot.vim' },

            -- Language specific styling
            { 'styled-components/vim-styled-components' },
            { 'Vimjas/vim-python-pep8-indent' },

            -- UI
            -- ryanoasis/vim-devicons'
            { 'kyazdani42/nvim-web-devicons' },
            {
                'nvim-lualine/lualine.nvim',
                config = function()
                    require('plugins.lualine')
                end,
            },
            {
                'akinsho/bufferline.nvim',
                config = function()
                    require('plugins.bufferline')
                end,
            },
            {
                'rcarriga/nvim-notify',
                config = function()
                    require('plugins.notify')
                end,
            },
            {
                'norcalli/nvim-colorizer.lua',
                config = function()
                    require('plugins.colorizer')
                end,
            },
            { 'yamatsum/nvim-cursorline' },
            {
                'SmiteshP/nvim-gps',
                config = function()
                    require('plugins.gps')
                end,
            },
            {
                'folke/which-key.nvim',
                config = function()
                    require('plugins.which-key')
                end,
            },
            {
                'luukvbaal/stabilize.nvim',
                config = function()
                    require('plugins.stabilize')
                end,
            },

            -- Themes
            -- {
            --     'catppuccin/nvim',
            --     config = function()
            --         require('plugins.colorschemes.catppuccin')
            --     end,
            -- },
            {
                'folke/tokyonight.nvim',
                config = function()
                    require('plugins.colorschemes.tokyonight')
                end,
            },

            -- Other
            {
                'kdheepak/lazygit.nvim',
                cmd = 'LazyGit',
                config = function()
                    require('plugins.lazygit')
                end,
            },
            {
                'voldikss/vim-floaterm',
                cmd = { 'FloatermNew', 'FloatermToggle' },
            },
            {
                'AckslD/nvim-neoclip.lua',
                config = function()
                    require('plugins.neoclip')
                end,
            },
            { 'famiu/bufdelete.nvim', cmd = { 'Bdelete', 'Bwipeout' } },
            {
                'tpope/vim-fugitive',
                cmd = {
                    'Git',
                    'Gedit',
                    'Gsplit',
                    'Gdiffsplitt',
                    'Gread',
                    'Gwrite',
                    'Ggrep',
                    'GMove',
                    'GRename',
                    'GDelete',
                    'GRemove',
                    'GBrowse',
                },
            },
            { 'famiu/nvim-reload', cmd = { 'Reload', 'Restart' } },

            -- Notes
            {
                'jakewvincent/mkdnflow.nvim',
                ft = { 'markdown' },
                config = function()
                    require('plugins.mkdnflow')
                end,
            },
            {
                'Pocco81/TrueZen.nvim',
                ft = { 'markdown' },
                config = function()
                    require('plugins.truezen')
                end,
            },
            -- { 'jbyuki/nabla.nvim', ft = { 'markdown' } }, -- In case I need math

            -- My Plugins
            { 'lukamanitta/naturally.nvim' },
        })
    end,
    config = {
        display = {
            open_fn = require('packer.util').float,
        },
        profile = {
            enable = true,
            threshold = 1,
        },
    },
})
