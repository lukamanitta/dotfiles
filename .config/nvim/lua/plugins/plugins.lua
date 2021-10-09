-- Auto-installer packer.nvim if not installed
local cmd, fn = vim.cmd, vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    cmd 'packadd packer.nvim'
end

local init = {
    -- Packer can manage itself as an optional plugin
    'wbthomason/packer.nvim',
    -- opt = true
}

local explorer = {
    'kyazdani42/nvim-tree.lua',
}

local finder = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-lua/popup.nvim',
    {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
}

local objects_movements = {
    'terrortylor/nvim-comment',
    'JoosepAlviste/nvim-ts-context-commentstring',
    'lukas-reineke/indent-blankline.nvim',
    'chun-yang/auto-pairs',
    'tpope/vim-surround',
    'bkad/CamelCaseMotion',
    'andymass/vim-matchup',
}

local lsp_completions = {
    'kabouzeid/nvim-lspinstall',
    'neovim/nvim-lspconfig',
    'hrsh7th/nvim-compe',
    'folke/trouble.nvim',
    {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'},
    'kosayoda/nvim-lightbulb', -- Highlight code actions
    'weilbith/nvim-code-action-menu', -- Code action popup
    'windwp/nvim-ts-autotag',
}

local lang_specific_styling = {
    'styled-components/vim-styled-components',
}

local ui = {
    'ryanoasis/vim-devicons',
    'kyazdani42/nvim-web-devicons',
    'hoob3rt/lualine.nvim',
    'akinsho/bufferline.nvim',
    'rcarriga/nvim-notify',
}

local themes = {
    'morhetz/gruvbox',
    'Pocco81/Catppuccino.nvim',
    'https://gitlab.com/protesilaos/tempus-themes-vim.git',
}

local other = {
    'voldikss/vim-floaterm',
}

require('packer').startup {
    {
        init,
        explorer,
        finder,
        objects_movements,
        lsp_completions,
        lang_specific_styling,
        ui,
        themes,
        other,
    },
    config = {
        display = {
            open_fn = require'packer.util'.float
        }
    }
}
