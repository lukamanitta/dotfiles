filetype plugin indent on

set nocp                        " Fixes starting in terminal for some reason

" Key mappings
imap jk <Esc>|                  " Remap jk to enter normal mode
nnoremap ; :|                   " Remap ; to start command
nnoremap <SPACE> <Nop>|         " Remap leader to space
let mapleader = " "|
nnoremap <leader>a <C-^>|       " Swap to alternate file

map <leader>h :wincmd h<CR>|    " Space + direction for window navigation
map <leader>j :wincmd j<CR>|
map <leader>k :wincmd k<CR>|
map <leader>l :wincmd l<CR>|

map // :nohlsearch<CR>; echo 'Search highlight cleared' <CR>| " Clears the previous search highlight

" autocmd group (clears autocmds)
augroup vimrc_autocmd
    autocmd!
    " Jump to last position when reopening a file
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Editor / UI Settings
syntax on                       " Vim syntax highlighting
set synmaxcol=200               " Only highlight 200 columns
set cursorline                  " Cursor line :)
set relativenumber              " Enables relative line numbers
set number                      " Enable hybrid line mode
set hidden                      " Leave buffer without saving

set scrolloff=8
set sidescrolloff=5

set ttyfast                     " Faster redraw
set lazyredraw                  " Smarter redraw
set report = 0                  " Always report changed lines


set laststatus=2                " Status line always visible
set encoding=utf-8

" Indent
set autoindent
set expandtab                   " Treat tabs as multiple spaces
set softtabstop=4
set shiftwidth=4                " Tab length = 4 spaces
set shiftround                  " >> indents to next multiple of shiftwidth

set showmode                    " Show current mode in cmd-line
set showcmd                     " Show pending keys in cmd-line

set wildmenu                    " Show autocomplete options above cmd-line

set incsearch                   " Highlight while searching
set hlsearch                    " Keep matches highlighted
set wrapscan                    " Searches wrap around top / end of file

set list                        " Show non-printable characters.
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

set backspace=indent,eol,start
set belloff=all                 " Shut that fucking bell sound off
call matchadd('ColorColumn', '\%80v', 100) " DANGER ZONE FUCK NO NOT 80 CHARS FU

" colorscheme zellner

" File finding
" Sub-dir searching and tab-completion
set path+=**

" File explorer
nnoremap <leader>e :Lexplore<CR>
let g:netrw_banner = 0
let g:netrw_winsize = 15
let g:netrw_liststyle = 3 " Tree view
" let g:netrw_list_hide = netrw_gitignore#Hide()
let g:netrw_list_hide .= ',\(^\|\s\s\)\zs\.\S\+'

" Tags
" Generate tags file for project (run from root dir)
" TODO: Add git hooks, place in .git/ if present
command! MakeTags !ctags -R .

" Goto definition
nnoremap gd ^]

" Get all declarations
nnoremap gD g^]

" Jump back through tag jumps with ^t

" Autocomplete
" Multi-purpose tab key (insert space if at start of line, autocomplete
" otherwise
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-n>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-p>

" Code folding
set foldmethod=indent           " Fold based on indent
set foldnestmax=10              " Deepest fold is 10 levels
set nofoldenable                " Don't fold by default
set foldlevel=1
