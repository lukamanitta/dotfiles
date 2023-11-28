-- TODO: rewrite these in lua
local exec = vim.api.nvim_exec

exec(
    [[
augroup nvim
    au!
    " Jump to last position when reopening
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

    " Enable spell for markdown
    au FileType markdown setlocal spell
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
