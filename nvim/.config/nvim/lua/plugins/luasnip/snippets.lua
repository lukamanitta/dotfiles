local ls = require("luasnip")
local fn = vim.fn
local shell = require("utils.helpers").shell

local s = ls.snippet

local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

-- TODO: Move these into separate files

ls.add_snippets("lua", {
    s("mysnippet", fmt('local {} = require("{}")', { i(1, "default"), rep(1) })),
})

ls.add_snippets("markdown", {
    s(
        "note",
        fmt(
            [[
    ---
    course: {}
    date: {}
    ---

    # {}
    ]],
            {
                shell("pwd | egrep -o '[A-Z]{4}[0-9]{4}' | tail -1"),
                shell("date +%Y/%m/%d"),
                i(0, "Title"),
            }
        )
    ),
})

require("luasnip.loaders.from_vscode").lazy_load()
