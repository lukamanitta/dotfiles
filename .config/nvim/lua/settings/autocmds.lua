local exec = vim.api.nvim_exec

exec(
[[
augroup nvim
    au!

    " Jump to last position when reopening
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

    " Trim whitespace on save
    au BufWritePre * :lua require('utils.functions').trim_whitespace()

    " PackerCompile on plugin change
    au BufWritePost plugins.lua source <afile> | PackerCompile

augroup END
]],
""
)
    -- " Startup layout
    -- au VimEnter * :lua require('utils.functions').startup_layout()

