filetype plugin indent on

" Key mappings
map <C-n> :NERDTreeToggle<CR>
nnoremap <silent> <C-f> :Files<CR>
nnoremap <C-b> :buffers<CR>:buffer<Space>
nnoremap <Leader>c* /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgn
nnoremap <Leader>c# ?\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgN

" Plugins

call plug#begin('~/vimfiles/plugged')

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'preservim/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='bubblegum'
Plug 'yggdroot/indentline'
Plug 'chun-yang/auto-pairs'
Plug 'valloric/youcompleteme', { 'do': 'py install.py --all' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'omnisharp/omnisharp-vim'
Plug 'pangloss/vim-javascript'

call plug#end()

" Editor / GUI Settings
"fullscreen
au GUIEnter * simalt ~x
syntax on
set number
colorscheme gruvbox
set laststatus=2
set encoding=utf-8
set guifont=Fira_Code:h11:cANSI:qDRAFT
set expandtab
set shiftwidth=4
set go -=m
set go -=T
set backspace=indent,eol,start
set belloff=all

" Code folding
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" YouCompleteMe
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_autoclose_preview_window_after_completion = 1
