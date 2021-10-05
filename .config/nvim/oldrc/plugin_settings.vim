" Airline
let g:airline#extensions#tabline#enabled = 1

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

