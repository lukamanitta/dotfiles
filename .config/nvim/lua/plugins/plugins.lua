-- Auto-installer packer.nvim if not installed

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    execute 'packadd packer.nvim'
end

local init = {
    -- Packer can manage itself as an optional plugin
    'wbthomason/packer.nvim',
    opt = true
}

local explorer = {
    'kyazdani42/nvim-tree.lua',
}

local finder = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-lua/popup.nvim',
}

local objects_movements = {
    'preservim/nerdcommenter',
    'lukas-reineke/indent-blankline.nvim',
    'chun-yang/auto-pairs',
    'tpope/vim-surround',
    'bkad/CamelCaseMotion'
}

local lsp_completions = {
    'kabouzeid/nvim-lspinstall', -- TODO: Add auto server install post-install hook here
    'neovim/nvim-lspconfig',
    'hrsh7th/nvim-compe',
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
    'vim-airline/vim-airline',
    'vim-airline/vim-airline-themes',
    'akinsho/bufferline.nvim',
}

local themes = {
    'morhetz/gruvbox',
    'Pocco81/Catppuccino.nvim',
    'https://gitlab.com/protesilaos/tempus-themes-vim.git',
}

local packer = require('packer')
packer.startup {
    {
        init,
        explorer,
        finder,
        objects_movements,
        lsp_completions,
        lang_specific_styling,
        ui,
        themes,
    },
    config = {
        display = {
            open_fn = require'packer.util'.float
        }
    }
}
