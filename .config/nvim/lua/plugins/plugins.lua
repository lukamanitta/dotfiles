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
        -- Packer can manage itself as an optional plugin
        use({ 'wbthomason/packer.nvim', opt = true })

        -- File explorer
        use({
            'kyazdani42/nvim-tree.lua',
            cmd = { 'NvimTreeToggle' },
            setup = function()
                require('plugins.nvimtree')
            end,
        })

        -- Finder
        use({ 'nvim-lua/plenary.nvim' })
        use({ 'nvim-lua/popup.nvim' })
        use({
            'nvim-telescope/telescope.nvim',
            cmd = { 'Telescope' },
            setup = function()
                require('plugins.telescope')
            end,
        })
        use({
            'nvim-telescope/telescope-fzf-native.nvim',
            run = 'make',
            after = 'telescope.nvim',
        })

        -- Objects and Movements
        use({ 'terrortylor/nvim-comment' })
        use({ 'JoosepAlviste/nvim-ts-context-commentstring' })
        use({ 'lukas-reineke/indent-blankline.nvim' })
        use({ 'chun-yang/auto-pairs' })
        use({ 'tpope/vim-surround' })
        use({ 'bkad/CamelCaseMotion' })
        use({ 'andymass/vim-matchup' })
        use({ 'easymotion/vim-easymotion' })

        -- Lsp & Completions
        use({ 'kabouzeid/nvim-lspinstall' })
        use({ 'neovim/nvim-lspconfig' })
        use({ 'hrsh7th/nvim-compe' })
        use({ 'folke/trouble.nvim' })
        use({ 'glepnir/lspsaga.nvim' })
        use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
        use({ 'windwp/nvim-ts-autotag' })
        use({ 'dense-analysis/ale' })

        -- Language specific styling
        use({ 'styled-components/vim-styled-components' })
        use({ 'Vimjas/vim-python-pep8-indent' })

        -- UI
        -- 'ryanoasis/vim-devicons'
        use({ 'kyazdani42/nvim-web-devicons' })
        use({
            'hoob3rt/lualine.nvim',
            after = 'Catppuccino.nvim',
            setup = function()
                require('plugins.lualine')
            end,
        })
        use({ 'akinsho/bufferline.nvim' })
        use({ 'rcarriga/nvim-notify' })
        use({ 'norcalli/nvim-colorizer.lua' })
        use({ 'yamatsum/nvim-cursorline' })
        use({ 'SmiteshP/nvim-gps' })
        use({ 'folke/which-key.nvim' })

        -- Themes
        use({ 'Pocco81/Catppuccino.nvim' })

        -- Other
        use({
            'voldikss/vim-floaterm',
            cmd = { 'FloatermNew', 'FloatermToggle' },
        })
        use({ 'famiu/bufdelete.nvim', cmd = { 'BufDelete' } })
        use({ 'AckslD/nvim-neoclip.lua' })
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
