" Editor / UI Settings
syntax on               "Vim syntax highlighting
set relativenumber      "Enables relative line numbers
set number              "Enable hybrid line mode
set hidden

set lazyredraw
set ttyfast
set re=1

set termguicolors
set background=dark
colorscheme palenight
let g:airline_theme='palenight'
let g:palenight_terminal_italics=1

" Transparent background
"highlight Normal guibg=none
"highlight NonText guibg=none

set cursorline

set laststatus=2        "Status line always visible
set encoding=utf-8
" set guifont=FiraCode-Regular:h13
set guifont=Apl386\ Unicode\ Nerd\ Font:h15
set expandtab           "Treat tabs as multiple spaces
set shiftwidth=4        "Tab length = 4 spaces
set backspace=indent,eol,start
set belloff=all         "Shut that fucking bell sound off
set colorcolumn=80,100  "Line length DANGER ZONE NO PLS NO FUCK AHH NOT 80 CHARA

if has("gui_running")
    set lines=999 columns=999
"else
  "" Terminal Vim
  "if exists("+lines")
    "set lines=50
  "endif
  "if exists("+columns")
    "set columns=100
  "endif
endif


"Open layout and background terminal
function! InitialSetup()
    let l:filename_given = argc() != 0
    let l:filename_argument_bufh = nvim_win_get_buf(0)

    "Background terminal
    enew | call termopen(&shell) | call SetBuffer(0)
    if l:filename_given
        "Return to file passed to cmd
        call nvim_win_set_buf(0, l:filename_argument_bufh)
    else
        "Open empty buffer
        enew
    end

    call vwm#open("bottom_term")
endfunction

autocmd VimEnter * call InitialSetup()


"No window manager splits
"Create a 'utility' terminal
"set splitbelow
"au VimEnter * new | call termopen(&shell) | execute 'resize 12' | wincmd p
"
"Start NERDTree & vista when Vim is started without file arguments.
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | wincmd p | endif


" Code folding
set foldmethod=indent   "Fold based on indent
set foldnestmax=10      "Deepest fold is 10 levels
set nofoldenable        "Don't fold by default
set foldlevel=1
