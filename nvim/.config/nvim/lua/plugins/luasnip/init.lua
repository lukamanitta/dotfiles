local types = require("luasnip.util.types")
local general_icons = require("assets.icons").general

require("luasnip").config.set_config({
    -- Allows jumping back into snippet after exiting selection
    history = true,
    -- Update dynamic values inside snippets while typing
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = false,
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { general_icons.CircleOutline, "Conditional" } },
            },
        },
    },
    snip_env = {
        s = require("luasnip.nodes.snippet").S,
        sn = require("luasnip.nodes.snippet").SN,
        t = require("luasnip.nodes.textNode").T,
        fn = require("luasnip.nodes.functionNode").F,
        i = require("luasnip.nodes.insertNode").I,
        c = require("luasnip.nodes.choiceNode").C,
        d = require("luasnip.nodes.dynamicNode").D,
        r = require("luasnip.nodes.restoreNode").R,
        l = require("luasnip.extras").lambda,
        rep = require("luasnip.extras").rep,
        p = require("luasnip.extras").partial,
        m = require("luasnip.extras").match,
        n = require("luasnip.extras").nonempty,
        dl = require("luasnip.extras").dynamic_lambda,
        fmt = require("luasnip.extras.fmt").fmt,
        fmta = require("luasnip.extras.fmt").fmta,
        conds = require("luasnip.extras.expand_conditions"),
        types = require("luasnip.util.types"),
        events = require("luasnip.util.events"),
        parse = require("luasnip.util.parser").parse_snippet,
        ai = require("luasnip.nodes.absolute_indexer"),
    },
})

require("luasnip.loaders.from_lua").load({
    paths = { "~/.config/nvim/lua/plugins/luasnip/snippets" },
})
require("luasnip.loaders.from_vscode").lazy_load()

vim.keymap.set(
    "n",
    "<leader><leader>ls",
    "<CMD>source ~/.config/nvim/lua/plugins/luasnip/snippets.lua<CR>"
)

vim.keymap.set("i", "<CTRL-u>", function()
    return require("luasnip.extras.select_choice")()
end)
