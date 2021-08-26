
" Key mappings
inoremap jk <Esc>
nnoremap ; :
nnoremap <SPACE> <Nop>
let mapleader = " "
nnoremap <leader>a <C-^>

"leader + direction for window navigation
map <leader>h :wincmd h<CR>
map <leader>j :wincmd j<CR>
map <leader>k :wincmd k<CR>
map <leader>l :wincmd l<CR>

"Make capital Y yanking work normally consistently with other capita letters
nnoremap Y y$

"Keep cursor centered when cycling through search results & expand folds
nnoremap n nzzzv
nnoremap N Nzzzv

map //  :nohlsearch<CR>; echo 'Search highlight cleared' <CR>

"Leave ins mode in terminal
tnoremap jk <C-\><C-n>

"Reload files open in buffers (can fix syntax)
map <leader>r :call ReloadBufferFiles()

nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
