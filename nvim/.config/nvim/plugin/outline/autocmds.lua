vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if vim.bo.filetype == "Outline" and vim.fn.winnr("$") == 1 then
            vim.cmd("q")
        end
    end,
})
