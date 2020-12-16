filetype plugin indent on

" Key mappings
noremap <C-[> <Esc>|											  "Remap C-[ to enter normal mode
nnoremap ; :|                                                     "Remap ; to start command
nnoremap <SPACE> <Nop>|                                           "Remap leader to space
let mapleader = " "|
map <C-n> :NERDTreeToggle<CR>|                                    "Toggle NERDTree
nnoremap <C-b> :buffers<CR>:buffer<Space>|                        "See all available buffers, enter number to change buffer
nnoremap <Leader>c* /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgn|  "Change all instances of word
nnoremap <Leader>c# ?\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgN|
map <leader>h :wincmd h<CR>|                                      "Space + direction for window navigation
map <leader>j :wincmd j<CR>|
map <leader>k :wincmd k<CR>|
map <leader>l :wincmd l<CR>|


" Plugins

call plug#begin('~/vimfiles/plugged')

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'preservim/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='bubblegum'
Plug 'morhetz/gruvbox'
Plug 'yggdroot/indentline'
Plug 'chun-yang/auto-pairs'
Plug 'valloric/youcompleteme', { 'do': 'py install.py --all' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'omnisharp/omnisharp-vim', { 'do': ':OmniSharpInstall' }
Plug 'pangloss/vim-javascript'
Plug 'vim-ruby/vim-ruby'

call plug#end()

" Editor / GUI Settings
au GUIEnter * simalt ~x "Make fullscreen
syntax on               "Vim syntax highlighting
set relativenumber      "Enables relative line numbers
set number              "Enable hybrid line mode
colorscheme gruvbox     "Best colour scheme
set laststatus=2        "Status line always visible
set encoding=utf-8
set guifont=Fira_Code:h11:cANSI:qDRAFT
set expandtab           "Treat tabs as multiple spaces
set shiftwidth=4        "Tab length = 4 spaces
set go -=m              "Hide GUI
set go -=T              "Hide GUI
set backspace=indent,eol,start
set belloff=all         "Shut that fucking bell sound off
set colorcolumn=80,100  "Line length danger zone

" Code folding
set foldmethod=indent   "Fold based on indent
set foldnestmax=10      "Deepest fold is 10 levels
set nofoldenable        "Don't fold by default
set foldlevel=1

" Python3 version
" set pythonthreedll = 'C:\Users\lukab\AppData\Local\Programs\Python\Python38-32\python38.dll'

" Airline
let g:airline#extensions#tabline#enabled = 1

" Syntastic
set statusline+=%#warningmsg#                  "Add syntastic notifs to statusline
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_python_exec = 'python3' "Use Python3

" YouCompleteMe
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_autoclose_preview_window_after_completion = 1
nnoremap <silent> <Leader>gd :YcmCompleter GoTo<CR>|  "Go to definition on gd

" fzf
nnoremap <silent> <C-f> :Files<CR>| "File search with ctrl-f
let g:fzf_preview_window = ''      "No preview window
