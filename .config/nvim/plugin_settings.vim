" Airline
let g:airline#extensions#tabline#enabled = 1

" NerdTree
let NERDTreeShowLineNumbers=1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeShowHidden = 1
" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

" Vista
let g:vista#renderer#enable_icon = 1
let g:vista_stay_on_open = 0
let g:vista_fzf_preview = ['right:50%']
let g:vista_sidebar_position = 'vertical topleft'

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
