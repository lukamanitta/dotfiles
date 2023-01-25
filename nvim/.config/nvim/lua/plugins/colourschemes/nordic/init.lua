require("nordic").setup({
    telescope = {
        -- Available styles: `classic`, `flat`.
        style = "flat",
    },
    -- These can contain anything that neovim understands.
    -- (fg, bg, italic, bold, etc.)
    syntax = {
        comments = {
            italic = true,
            bold = false,
        },
        operators = {
            italic = false,
            bold = true,
        },
        keywords = {
            italic = false,
            bold = true,
        },
    },
})

require("nordic").load()

require("plugins.colourschemes.nordic.custom_hl")
