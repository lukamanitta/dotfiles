local exec = vim.api.nvim_exec

exec(
    [[
augroup nvim
    au!

    " Jump to last position when reopening
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

    " PackerCompile on plugin change
    au BufWritePost */plugins/init.lua source <afile> | PackerCompile

    " Remind me about note snippet
    "au FileType markdown lua vim.notify("Type 'note' for note snippet!")

    " Enable spell for markdown
    au FileType markdown setlocal spell

    " Show cursorline only in current window
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline

    " au BufRead,BufNewFile *.flex,*.jflex set filetype=jflex
    " au Syntax jflex so ~/.config/nvim/after/syntax/jflex.vim

augroup END
]],
    false
)

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("yank_highlight", {}),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("nocursorline", {}),
    pattern = { "TelescopePrompt", "neo-tree-popup" },
    callback = function()
        vim.cmd("setlocal nocursorline")
    end,
})
