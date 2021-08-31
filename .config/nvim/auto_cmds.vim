" Auto Commands
augroup luka
    autocmd!

    " Refresh NerdTree when tabbing to buffer
    "autocmd BufEnter NERD_tree_* | execute 'normal R'

    " Jump to last position when reopening a file
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

    " Trim whitespace on save
    autocmd BufWritePre * :call TrimWhitespace()

augroup END
