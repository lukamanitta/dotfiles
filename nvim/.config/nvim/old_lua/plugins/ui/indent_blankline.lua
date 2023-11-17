local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local multiply_hex_brightness = require("utils.color").multiply_hex_brightness

local style_options = {}

if require("settings.globals").float_style == "flat" then
    vim.cmd("hi! link IndentBlanklineIndent1 Normal")
    vim.cmd(
        "hi! IndentBlanklineIndent2 guibg="
        .. multiply_hex_brightness(get_hi_group_bg("Normal"), -0.15)
    )

    style_options = {
        char = "",
        char_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
        },
        space_char_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
        },
        show_trailing_blankline_indent = false,
    }
elseif require("settings.globals").float_style == "classic" then
    for i = 1, 7 do
        vim.cmd(
            "hi! link IndentBlanklineIndent" .. i .. " rainbowcol" .. 7 - i + 1
        )
    end

    style_options = {
        char = "▏", --  "┆", "┊", "", "▏", "|"
        char_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
            "IndentBlanklineIndent3",
            "IndentBlanklineIndent4",
            "IndentBlanklineIndent5",
            "IndentBlanklineIndent6",
            "IndentBlanklineIndent7",
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
        },
    }
end

require("indent_blankline").setup(vim.tbl_deep_extend("force", style_options, {
    buftype_exclude = { "terminal" },
    filetype_exclude = {
        "packer",
        "lspinfo",
        "Trouble",
        "lsp-installer",
        "neo-tree",
        "neo-tree-popup",
        "mason",
        "TelescopePrompt",
        "notify",
    },
    show_current_context = true,
    show_current_context_start = false,
    use_treesitter = true,
}))

vim.cmd(
    "hi IndentBlanklineContextChar" -- .. "guibg="
    -- .. get_hi_group_fg("Normal")
    .. " guifg="
    .. get_hi_group_fg("Normal")
)
