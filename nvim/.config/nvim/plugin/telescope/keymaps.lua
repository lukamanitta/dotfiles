vim.keymap.set("n", "<LEADER>fs", ":Telescope lsp_document_symbols<CR>", {
    silent = true,
    desc = "Search document symbols",
})

vim.keymap.set("n", "<LEADER>fas", function()
    return require("telescope.builtin").lsp_workspace_symbols()
end, { silent = true, desc = "Search workspace symbols" })
