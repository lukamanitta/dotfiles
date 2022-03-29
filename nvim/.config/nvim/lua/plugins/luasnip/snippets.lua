local ls = require("luasnip")

-- Snippet creator
-- s(<trigger>, <nodes>)
local s = ls.s

-- Format node
-- Takes a format string and list of nodes
local fmt = require("luasnip.extras.fmt").fmt

-- Insert node
-- Takes position (e.g. $1), and optionally default text
-- i(<position>, [default_text])
local i = ls.insert_node

-- Repeats a node
-- rep(<position>)
local rep = require("luasnip.extras").rep

ls.snippets = {
    lua = {
        s("req", fmt('local {} = require("{}")', { i(1, "default"), rep(1) })),
    },
}
