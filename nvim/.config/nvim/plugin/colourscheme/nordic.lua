if vim.g.colourscheme == "Nordic" then
    vim.pack.add({
        { src = "https://github.com/alexvzyl/nordic.nvim" },
    })

    require("nordic").setup({
        bold_keywords = true,
    })

    vim.cmd.colorscheme("nordic")
    require("ui.colourscheme_common")()
end
