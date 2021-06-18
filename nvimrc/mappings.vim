
" Key mappings
inoremap jk <Esc>|						          "Remap jk to enter normal mode
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
