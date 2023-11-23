-- TODO: clean dis up

vim.keymap.set("n", "<leader>ff", function()
    return require("plugins.telescope.tele_utils").smart_file_finder()
end, { silent = true })

vim.keymap.set("n", "<leader>fc", function()
    return require("telescope.builtin").git_status()
end, { silent = true }) -- Search project

vim.keymap.set("n", "<leader>fg", function()
    return require("telescope.builtin").live_grep()
end, { silent = true }) -- Search project

vim.keymap.set("n", "<leader>fs", "<CMD>Telescope lsp_document_symbols<CR>", {
    silent = true,
}) -- Search symbols

vim.keymap.set("n", "<leader>fas", function()
    return require("telescope.builtin").lsp_workspace_symbols()
end, { silent = true }) -- Search all project symbols

vim.keymap.set("n", "<leader>fb", function()
    require("telescope.builtin").buffers()
end, { silent = true }) -- Search buffers

vim.keymap.set("n", "<leader>fr", function()
    return require("telescope.builtin").resume()
end)

vim.keymap.set("n", "<leader>fm", function()
    return require("plugins.telescope.tele_utils").git_modified_finder()
end)

vim.keymap.set("n", "z=", function()
    return require("telescope.builtin").spell_suggest({
        prompt_title = false,
        layout_config = {
            height = 15,
        },
    })
end)

