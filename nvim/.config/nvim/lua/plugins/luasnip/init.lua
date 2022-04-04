local map = require("utils.config").map
local types = require("luasnip.util.types")

require("luasnip").config.set_config({
    -- Allows jumping back into snippet after exiting selection
    history = true,

    -- Update dynamic values inside snippets while typing
    updateevents = "TextChanged,TextChangedI",

    enable_autosnippets = true,
    -- ext_opts = {
    --     [types.choiceNode] = {
    --         active = {
    --             virt_text = { { "●", "GruvboxOrange" } },
    --         },
    --     },
    --     [types.insertNode] = {
    --         active = {
    --             virt_text = { { "●", "GruvboxBlue" } },
    --         },
    --     },
    -- },
})

require("plugins.luasnip.snippets")

map("n", "<leader><leader>ls", "<cmd>source ~/.config/nvim/lua/plugins/luasnip/snippets.lua<cr>")
