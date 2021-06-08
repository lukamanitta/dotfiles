filetype plugin indent on

set nocp                                                          "Fixes starting in terminal for some reason

" Key mappings
imap jk <Esc>|						          "Remap jk to enter normal mode
nnoremap ; :|                                                     "Remap ; to start command
nnoremap <SPACE> <Nop>|                                           "Remap leader to space
let mapleader = " "|
nnoremap <Leader>c* /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgn|  "Change all instances of word
nnoremap <Leader>c# ?\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgN|
nnoremap <leader>a <C-^>|                                          "Swap to alternate file

map <leader>h :wincmd h<CR>|                                      "Space + direction for window navigation
map <leader>j :wincmd j<CR>|
map <leader>k :wincmd k<CR>|
map <leader>l :wincmd l<CR>|

map //  :nohlsearch<CR>; echo 'Search highlight cleared' <CR>|    "Clears the previous search highlight

tnoremap jk <C-\><C-n>|                                           "Leave insert mode in terminal

nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Auto Commands
augroup vimrc_autocmd
    autocmd!

    " Refresh NerdTree when tabbing to buffer
    autocmd BufEnter NERD_tree_* | execute 'normal R'

    " Jump to last position when reopening a file
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

augroup END

" Plugins
"
" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin()
        " File Explorer
Plug 'scrooloose/nerdtree'
Plug 'xuyuanp/nerdtree-git-plugin'
"Plug 'vim-scripts/taglist.vim' deal with this later

        " Finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
"Plug 'nvim-lua/popup.nvim'
"Plug 'nvim-lua/plenary.nvim'
"Plug 'nvim-telescope/telescope.nvim'

        " Objects / Movements
Plug 'preservim/nerdcommenter'
Plug 'yggdroot/indentline'
Plug 'chun-yang/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'bkad/CamelCaseMotion'

        " Autocompletion / Intellisense
" Plug 'valloric/youcompleteme', { 'do': 'python3 install.py --clang-completer' }
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': 'install_coc_extensions'}
Plug 'omnisharp/omnisharp-vim', { 'do': ':OmniSharpInstall' }

        " Languages
Plug 'pangloss/vim-javascript'
Plug 'vim-ruby/vim-ruby'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'jparise/vim-graphql'
"Correct css styling inside styled components
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

        " Other
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'

        " Themes
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox' " let g:airline_theme='bubblegum'
Plug 'gosukiwi/vim-atom-dark' " let g:airline_theme='????????'
Plug 'hzchirs/vim-material' " let g:airline_theme='material'
Plug 'drewtempelmeyer/palenight.vim' " let g:airline_theme='palenight'

call plug#end()

" Editor / UI Settings
syntax on               "Vim syntax highlighting
set relativenumber      "Enables relative line numbers
set number              "Enable hybrid line mode
set hidden

set lazyredraw
set ttyfast
set re=1

set termguicolors
set background=dark
colorscheme palenight
let g:airline_theme='palenight'
let g:palenight_terminal_italics=1

highlight Normal guibg=none
highlight NonText guibg=none

set cursorline

set laststatus=2        "Status line always visible
set encoding=utf-8
" set guifont=FiraCode-Regular:h13
set guifont=Apl385\ Unicode\ Nerd\ Font:h15
set expandtab           "Treat tabs as multiple spaces
set shiftwidth=4        "Tab length = 4 spaces
set backspace=indent,eol,start
set belloff=all         "Shut that fucking bell sound off
set colorcolumn=80,100  "Line length DANGER ZONE NO PLS NO FUCK AHH NOT 80 CHARA

if has("gui_running")
    set lines=999 columns=999
"else
  "" Terminal Vim
  "if exists("+lines")
    "set lines=50
  "endif
  "if exists("+columns")
    "set columns=100
  "endif
endif

" Init Splits
set splitbelow
au VimEnter * new | call termopen(&shell) | execute 'resize 10'
" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | wincmd p | endif

" Code folding
set foldmethod=indent   "Fold based on indent
set foldnestmax=10      "Deepest fold is 10 levels
set nofoldenable        "Don't fold by default
set foldlevel=1

" Python3 version
" set pythonthreedll = 'C:\Users\lukab\AppData\Local\Programs\Python\Python38-32\python38.dll'

" Find files using Telescope command-line sugar.
"nnoremap <leader>ff <cmd>Telescope find_files<cr>
"nnoremap <leader>fg <cmd>Telescope live_grep<cr>
"nnoremap <leader>fb <cmd>Telescope buffers<cr>
"nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Airline
let g:airline#extensions#tabline#enabled = 1

" NerdTree
let NERDTreeShowLineNumbers=1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
map <C-n> :NERDTreeToggle<CR>|    "Open file explorer
map <leader>N :NERDTreeFind<CR>|  "Toggle file explorer
" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

" CamelCaseMotion
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
map <silent> ge <Plug>CamelCaseMotion_ge
sunmap w
sunmap b
sunmap e
sunmap ge

omap <silent> iw <Plug>CamelCaseMotion_iw
xmap <silent> iw <Plug>CamelCaseMotion_iw
omap <silent> ib <Plug>CamelCaseMotion_ib
xmap <silent> ib <Plug>CamelCaseMotion_ib
omap <silent> ie <Plug>CamelCaseMotion_ie
xmap <silent> ie <Plug>CamelCaseMotion_ie

" Syntastic
set statusline+=%#warningmsg#                  "Add syntastic notifs to statusline
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%{FugitiveStatusline()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_python_exec = 'python3' "Use Python3
autocmd VimEnter * SyntasticToggleMode " Passive mode by default

" COC
source $HOME/.config/nvim/plug-config/coc.vim

" fzf
nnoremap <silent> <leader>f :GitFiles<CR>|   "File search
nnoremap <silent> <leader>b :Buffers<CR>| "Buffer search
nnoremap <silent> <leader>s :Rg<CR>|      "Grep search in files

" Functions
" Add argument (can be negative, default 1) to global variable i.
" Return value of i before the change.
function Inc(...)
  let result = g:i
  let g:i += a:0 > 0 ? a:1 : 1
  return result
endfunction
