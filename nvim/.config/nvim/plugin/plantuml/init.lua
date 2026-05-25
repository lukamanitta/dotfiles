vim.pack.add({
    {
        src = "https://github.com/Maduki-tech/nvim-plantuml",
    },
})

require("plantuml").setup({
    output_dir = "/tmp",
    viewer = "open",
    auto_refresh = true,
})
