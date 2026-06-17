if vim.g.colourscheme == "Everforest Medium" then
    vim.pack.add({
        { src = "https://github.com/neanias/everforest-nvim" },
    })

    require("everforest").setup({})

    vim.cmd.colorscheme("everforest")
    require("ui.colourscheme_common")()
end
