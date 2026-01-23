return function()
    local line = vim.fn.line(".")
    local line_count = vim.api.nvim_buf_line_count(0)
    local col = vim.fn.virtcol(".")

    return table.concat({
        "%#Italic#l: ",
        string.format("%%#StatuslineTitle#%d", line),
        string.format("%%#Italic#/%d c: %d", line_count, col),
    })
end
