filetype plugin indent on

set nocp                                                          "Fixes starting in terminal for some reason

" Key mappings
imap jk <Esc>|						          "Remap C-[ to enter normal mode
nnoremap ; :|                                                     "Remap ; to start command
nnoremap <SPACE> <Nop>|                                           "Remap leader to space
let mapleader = " "|
map <C-n> :NERDTreeToggle<CR>|                                    "Toggle file explorer
nnoremap <C-b> :buffers<CR>:buffer<Space>|                        "See all available buffers, enter number to change buffer
nnoremap <Leader>c* /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgn|  "Change all instances of word
nnoremap <Leader>c# ?\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgN|
map <leader>h :wincmd h<CR>|                                      "Space + direction for window navigation
map <leader>j :wincmd j<CR>|
map <leader>k :wincmd k<CR>|
map <leader>l :wincmd l<CR>|
map //  :nohlsearch<CR>; echo 'Search highlight cleared' <CR>     "Clears the previous search highlight

" Auto Commands
autocmd BufEnter NERD_tree_* | execute 'normal R'| " Refresh NerdTree file tree when tabbing to buffer

" Plugins
"
" auto-install vim-plug                                                                                                                
if empty(glob('~/.config/nvim/autoload/plug.vim'))                                                                                    
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \                                                                  
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim                                                             
  autocmd VimEnter * PlugInstall                                                                                                      
endif                     

call plug#begin()
        " File Explorer
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'xuyuanp/nerdtree-git-plugin'

        " Objects / Movements
Plug 'preservim/nerdcommenter'
Plug 'yggdroot/indentline'
Plug 'chun-yang/auto-pairs'
Plug 'tpope/vim-surround'

        " Autocompletion / Intellisense
" Plug 'valloric/youcompleteme', { 'do': 'python3 install.py --clang-completer' }
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': 'install_coc_extensions'}
Plug 'omnisharp/omnisharp-vim', { 'do': ':OmniSharpInstall' }

        " Languages
Plug 'pangloss/vim-javascript'
Plug 'vim-ruby/vim-ruby'

        " Other
Plug 'scrooloose/syntastic'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'

        " Themes
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox' " let g:airline_theme='bubblegum' 
Plug 'gosukiwi/vim-atom-dark' " let g:airline_theme='????????'
Plug 'hzchirs/vim-material' " let g:airline_theme='material'
Plug 'drewtempelmeyer/palenight.vim' " let g:airline_theme='palenight' 

call plug#end()

" Editor / GUI Settings
" au GUIEnter * simalt ~x "Make fullscreen
syntax on               "Vim syntax highlighting
set relativenumber      "Enables relative line numbers
set number              "Enable hybrid line mode

set termguicolors
set background=dark
colorscheme palenight
let g:airline_theme='palenight'
let g:palenight_terminal_italics=1

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

" Code folding
set foldmethod=indent   "Fold based on indent
set foldnestmax=10      "Deepest fold is 10 levels
set nofoldenable        "Don't fold by default
set foldlevel=1

" Python3 version
" set pythonthreedll = 'C:\Users\lukab\AppData\Local\Programs\Python\Python38-32\python38.dll'

" Airline
let g:airline#extensions#tabline#enabled = 1

" NerdTree
let NERDTreeShowLineNumbers=1

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

" YouCompleteMe
"let g:ycm_add_preview_to_completeopt = 0
"let g:ycm_autoclose_preview_window_after_completion = 1
"nnoremap <silent> <Leader>gd :YcmCompleter GoTo<CR>|  "Go to definition on gd

" COC
source $HOME/.config/nvim/plug-config/coc.vim

" fzf
nnoremap <silent> <C-f> :Files<CR>| "File search with ctrl-f
let g:fzf_preview_window = ''      "No preview window

set backupdir=$TMPDIR//
set directory=$TMPDIR//

" Functions
" Add argument (can be negative, default 1) to global variable i.
" Return value of i before the change.
function Inc(...)
  let result = g:i
  let g:i += a:0 > 0 ? a:1 : 1
  return result
endfunction
