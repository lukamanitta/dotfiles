if vim.g.colourscheme == "Nord" then
    vim.pack.add({
        { src = "https://github.com/shaunsingh/nord.nvim" },
    })

    vim.cmd.colorscheme("nord")
    require("ui.colourscheme_common")()
end
