if vim.g.colourscheme == "Ayu" then
    vim.pack.add({
        { src = "https://github.com/Shatur/neovim-ayu" },
    })

    require("ayu").setup({})

    vim.cmd.colorscheme("ayu")
end
