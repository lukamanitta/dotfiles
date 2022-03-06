filetype plugin indent on

set nocp                                                          "Fixes starting in terminal for some reason

" Key mappings
imap jk <Esc>|						          "Remap jk to enter normal mode
nnoremap ; :|                                                     "Remap ; to start command
nnoremap <SPACE> <Nop>|                                           "Remap leader to space
let mapleader = " "|
nnoremap <Leader>rn /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgn|  "Change all instances of word
nnoremap <Leader>c# ?\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgN|
nnoremap <leader>a <C-^>|                                          "Swap to alternate file

map <leader>h :wincmd h<CR>|                                      "Space + direction for window navigation
map <leader>j :wincmd j<CR>|
map <leader>k :wincmd k<CR>|
map <leader>l :wincmd l<CR>|

map //  :nohlsearch<CR>; echo 'Search highlight cleared' <CR>|    "Clears the previous search highlight

tnoremap jk <C-\><C-n>|                                           "Leave insert mode in terminal

" autocmd group (clears autocmds)
augroup vimrc_autocmd
    autocmd!
    " Jump to last position when reopening a file
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Editor / UI Settings
syntax on               "Vim syntax highlighting
set relativenumber      "Enables relative line numbers
set number              "Enable hybrid line mode
set hidden

set lazyredraw
set ttyfast
set re=1

set cursorline

set laststatus=2        "Status line always visible
set encoding=utf-8

set expandtab           "Treat tabs as multiple spaces
set shiftwidth=4        "Tab length = 4 spaces
set backspace=indent,eol,start
set belloff=all         "Shut that fucking bell sound off
call matchadd('ColorColumn', '\%80v', 100) " DANGER ZONE FUCK NO NOT 80 CHARS FU

colorscheme zellner

" File finding
" Sub-dir searching and tab-completion
set path+=**

" Display matchings files for tab completion
set wildmenu

" File explorer
nnoremap <leader>e :Lexplore <CR>
let g:netrw_banner = 0
let g:netrw_winsize = 15
let g:netrw_liststyle = 3 " Tree view
let g:netrw_list_hide = netrw_gitignore#Hide()
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
set foldmethod=indent   "Fold based on indent
set foldnestmax=10      "Deepest fold is 10 levels
set nofoldenable        "Don't fold by default
set foldlevel=1
