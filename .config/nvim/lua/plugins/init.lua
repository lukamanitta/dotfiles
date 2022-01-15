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
                cmd = { 'NvimTreeToggle' },
                config = function()
                    require('plugins.nvimtree')
                end,
            },

            -- Finder
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-lua/popup.nvim' },
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
            {
                'nvim-telescope/telescope.nvim',
                -- cmd = { 'Telescope' },
                config = function()
                    require('plugins.telescope')
                end,
            },

            -- Objects and Movements
            {
                'terrortylor/nvim-comment',
                config = function()
                    require('plugins.comment')
                end,
            },
            { 'JoosepAlviste/nvim-ts-context-commentstring' },
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
            { 'easymotion/vim-easymotion' },

            -- Lsp & Completions
            { 'williamboman/nvim-lsp-installer' },
            { 'neovim/nvim-lspconfig' },
            -- {
            --     'hrsh7th/nvim-compe',
            --     config = function()
            --         require('plugins.compe')
            --     end,
            -- },
            { 'folke/trouble.nvim' },
            { 'glepnir/lspsaga.nvim' },
            {
                'nvim-treesitter/nvim-treesitter',
                run = ':TSUpdate',
                config = function()
                    require('plugins.treesitter')
                end,
            },
            { 'windwp/nvim-ts-autotag' },
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
                },
            },

            -- Language specific styling
            { 'styled-components/vim-styled-components' },
            { 'Vimjas/vim-python-pep8-indent' },

            -- UI
            -- ryanoasis/vim-devicons'
            { 'kyazdani42/nvim-web-devicons' },
            {
                'hoob3rt/lualine.nvim',
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
                'lervag/wiki.vim',
                config = function()
                    require('plugins.wiki')
                end,
            },
            {
                'plasticboy/vim-markdown',
                ft = { 'markdown' },
                config = function()
                    require('plugins.markdown')
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
