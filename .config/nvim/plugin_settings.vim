" Airline
let g:airline#extensions#tabline#enabled = 1

" NerdTree
let NERDTreeShowLineNumbers=1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeShowHidden = 1
map <leader>n :NERDTreeToggle<CR>|    "Open file explorer
map <leader>N :NERDTreeFind<CR>|  "Toggle file explorer
" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

" Vista
let g:vista#renderer#enable_icon = 1
let g:vista_stay_on_open = 0
let g:vista_fzf_preview = ['right:50%']
let g:vista_sidebar_position = 'vertical topleft'


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

" Rust
let g:rustfmt_autosave = 1

" fzf
nnoremap <silent> <leader>f :GitFiles<CR>|   "File search
nnoremap <silent> <leader>b :Buffers<CR>| "Buffer search
nnoremap <silent> <leader>s :Rg<CR>|      "Grep search in files

" telescope
nnoremap <silent> <leader>f <cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' } })<cr>
nnoremap <silent> <leader>s <cmd>Telescope live_grep<cr>
nnoremap <silent> <leader>b <cmd>Telescope buffers<cr>
nnoremap <silent> <leader>ht <cmd>Telescope help_tags<cr>

lua << EOF
require('telescope').setup{
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--hidden',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--ignore-file',
            '.gitignore'
        },
    }
}
EOF

" vimtex
let g:vimtex_view_method = "skim"
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'
if has('nvim')
  let g:vimtex_compiler_progname = 'nvr'
endif

augroup vimtex_mac
    autocmd!
    autocmd User VimtexEventCompileSuccess call UpdateSkim()
augroup END

function! UpdateSkim() abort
    let l:out = b:vimtex.out()
    let l:src_file_path = expand('%:p')
    let l:cmd = [g:vimtex_view_general_viewer, '-r']

    if !empty(system('pgrep Skim'))
    call extend(l:cmd, ['-g'])
    endif

    call jobstart(l:cmd + [line('.'), l:out, l:src_file_path])
endfunction

nnoremap <leader>vtc :VimtexCompile<CR> | "Compile latex files with vtc
