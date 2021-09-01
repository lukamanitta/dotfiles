
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

"Make capital Y yanking work normally consistently with other capital letters
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

" Nvim Tree
nnoremap <leader>n :NvimTreeToggle<CR>

" FZF
"nnoremap <silent> <leader>f :GitFiles<CR>|   "File search
"nnoremap <silent> <leader>b :Buffers<CR>| "Buffer search
"nnoremap <silent> <leader>s :Rg<CR>|      "Grep search in files

" Telescope
nnoremap <silent> <leader>f <cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' } })<cr>
nnoremap <silent> <leader>s <cmd>Telescope live_grep<cr>
nnoremap <silent> <leader>b <cmd>Telescope buffers<cr>
nnoremap <silent> <leader>ht <cmd>Telescope help_tags<cr>

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
