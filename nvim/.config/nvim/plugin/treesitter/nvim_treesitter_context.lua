vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
})

require("treesitter-context").setup({
    max_line = 4,
    multiline_threshold = 2,
    separator = "·",
})
