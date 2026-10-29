if vim.g.colourscheme == "Catppuccin" then
    vim.pack.add({
        { src = "https://github.com/catppuccin/nvim" },
    })

    vim.cmd.colorscheme("catppuccin")
end
