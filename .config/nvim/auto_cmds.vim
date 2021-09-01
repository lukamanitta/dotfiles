" Auto Commands
augroup luka
    autocmd!

    "TODO: Refresh NvimTree when tabbing to buffer

    " Jump to last position when reopening a file
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

    " Trim whitespace on save
    autocmd BufWritePre * :call TrimWhitespace()

augroup END
