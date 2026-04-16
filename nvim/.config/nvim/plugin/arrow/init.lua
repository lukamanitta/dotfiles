vim.pack.add({
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

vim.pack.add({
    { src = "https://github.com/otavioschwanck/arrow.nvim" },
})

require("arrow").setup({
    show_icons = true,
    leader_key = ";",
    buffer_leader_key = "m",
    window = { border = "none" },
    per_buffer_config = {
        lines = 6,
    },
})
