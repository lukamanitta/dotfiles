require("luasnip").config.set_config({
    -- Allows jumping back into snippet after exiting selection
    history = true,

    -- Update dynamic values inside snippets while typing
    updateevents = "TextChanged,TextChangedI",

    enable_autosnippets = true,
})

require("plugins.luasnip.snippets")
require("luasnip.loaders.from_vscode").lazy_load()
