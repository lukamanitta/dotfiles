vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
})

vim.pack.add({
    { src = "https://github.com/nosduco/remote-sshfs.nvim" },
})

require("telescope").load_extension("remote-sshfs")

require("remote-sshfs").setup()
