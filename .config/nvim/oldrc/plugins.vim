" Plugins

" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin()
        " Explorer
Plug 'kyazdani42/nvim-tree.lua'

        " Window layouts
Plug 'paroxayte/vwm.vim'

        " Finder
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'junegunn/fzf.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/popup.nvim'

        " Objects / Movements
Plug 'preservim/nerdcommenter'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'chun-yang/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'bkad/CamelCaseMotion'

        " LSP & Completion
Plug 'kabouzeid/nvim-lspinstall', {'do': ':call InstallLspServers()'}
Plug 'neovim/nvim-lspconfig',
Plug 'nvim-lua/completion-nvim'

        " Autocompletion / Intellisense / Code Actions
"Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': ':call InstallCocExtensions()'}
"Plug 'omnisharp/omnisharp-vim', { 'do': ':OmniSharpInstall' }
Plug 'windwp/nvim-ts-autotag'
"Highlight code actions
Plug 'kosayoda/nvim-lightbulb'
"Code action popup
Plug 'weilbith/nvim-code-action-menu'


        " Languages / Syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"Correct css styling inside react styled components
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
"Maybe delete
"Plug 'pangloss/vim-javascript'
"Plug 'vim-ruby/vim-ruby'
"Plug 'tpope/vim-rails'
"Plug 'leafgarland/typescript-vim'
"Plug 'maxmellon/vim-jsx-pretty'
"Plug 'jparise/vim-graphql'
"Plug 'elzr/vim-json'
"Plug 'godlygeek/tabular'
"Plug 'plasticboy/vim-markdown'
"Plug 'vim-python/python-syntax'

        " Other
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'rcarriga/nvim-notify'

        " Themes
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons' " for nvim tree icons
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'akinsho/bufferline.nvim'
"Colours
Plug 'morhetz/gruvbox' " let g:airline_theme='bubblegum'
Plug 'gosukiwi/vim-atom-dark' " let g:airline_theme='????????'
Plug 'hzchirs/vim-material' " let g:airline_theme='material'
Plug 'drewtempelmeyer/palenight.vim' " let g:airline_theme='palenight'
Plug 'Pocco81/Catppuccino.nvim'
Plug 'https://gitlab.com/protesilaos/tempus-themes-vim.git'

call plug#end()

function! InstallCocExtensions()
    let extensions = [
        \"coc-css",
        \"coc-html",
        \"coc-html-css-support",
        \"coc-json",
        \"coc-pydocstring",
        \"coc-pyright",
        \"coc-sql",
        \"coc-tsserver",
        \"coc-vimlsp",
        \"coc-explorer",
        \"coc-emmet",
        \]

    execute "CocInstall " . join(extensions)
endfunction

function! InstallLspServers()
    let servers = [
        \"bash",
        \"csharp",
        \"css",
        \"graphql",
        \"html",
        \"json",
        \"latex",
        \"lua",
        \"python",
        \"ruby",
        \"rust",
        \"typescript",
        \"vim",
        \"yaml",
        \]

    for server in servers
        execute "LspInstall " . server
    endfor
endfunction
