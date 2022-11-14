local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg

for i = 1, 7 do
    vim.cmd("hi! link IndentBlanklineIndent" .. i .. " rainbowcol" .. i)
end

require("indent_blankline").setup({
    char = "┊", -- "┆", "┊", ""
    buftype_exclude = { "terminal" },
    filetype_exclude = {
        "packer",
        "lspinfo",
        "Trouble",
        "lsp-installer",
        "neo-tree",
        "neo-tree-popup",
        "mason",
    },
    show_current_context = true,
    show_current_context_start = true,
    use_treesitter = true,
    char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
        "IndentBlanklineIndent7",
    },
})

vim.cmd("hi IndentBlanklineContextChar guifg=" .. get_hi_group_fg("Normal"))
