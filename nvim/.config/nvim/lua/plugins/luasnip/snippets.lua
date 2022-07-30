local ls = require("luasnip")
local fn = vim.fn
local utils = require("plugins.luasnip.utils")
local shell = require("utils.helpers").shell
local course_regex = require("utils.helpers").course_regex

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
local lambda = require("luasnip.extras").l

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
                -- course_regex(),
                shell("pwd | egrep -o '[A-Z]{4}[0-9]{4}' | tail -1"),
                shell("date +%Y/%m/%d"),
                i(0, "Title"),
            }
        )
    ),
})

ls.add_snippets("c", {
    s("fn", {
        d(6, utils.cdocsnip, { 2, 4, 5 }),
        t({ "", "" }),
        c(1, {
            t("public "),
            t("private "),
        }),
        c(2, {
            t("void"),
            t("String"),
            t("char"),
            t("int"),
            t("double"),
            t("boolean"),
            i(nil, ""),
        }),
        t(" "),
        i(3, "myFunc"),
        t("("),
        i(4),
        t(")"),
        c(5, {
            t(""),
            sn(nil, {
                t({ "", " throws " }),
                i(1),
            }),
        }),
        t({ " {", "\t" }),
        i(0),
        t({ "", "}" }),
    }),
})

require("luasnip.loaders.from_vscode").lazy_load()
