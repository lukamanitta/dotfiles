if vim.g.colourscheme == "Mini Base16" then
    vim.pack.add({
        { src = "https://github.com/nvim-mini/mini.base16" },
    })

    require("mini.base16").setup({
        palette = require("ui.palettes.colourme"),
    })
end
