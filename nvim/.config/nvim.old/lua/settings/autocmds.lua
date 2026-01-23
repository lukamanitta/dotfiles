vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("jump_to_last_pos", {}),
    pattern = "*",
    callback = function()
        if
            vim.fn.line("'\"") > 1
            and vim.fn.line("'\"") <= vim.fn.line("$")
        then
            vim.cmd('normal! g`"')
        end
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("yank_highlight", {}),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
    end,
})
