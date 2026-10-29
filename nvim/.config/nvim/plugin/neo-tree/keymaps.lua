vim.keymap.set(
    "n",
    "<LEADER>e",
    ":Neotree focus filesystem float toggle reveal<CR>",
    { desc = "Toggle Neo-tree filesystem" }
)

vim.keymap.set(
    "n",
    "<LEADER>b",
    ":Neotree focus buffers float toggle reveal<CR>",
    { desc = "Toggle Neo-tree buffers" }
)
