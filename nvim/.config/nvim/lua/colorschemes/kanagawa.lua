local opts = {}

if vim.o.background == "dark" then
    opts = {
        colors = {
            theme = {
                all = {
                    ui = {
                        bg_gutter = "none",
                    },
                },
            },
        },
    }
elseif vim.o.background == "light" then
    opts = {
        theme = "light",
    }
end

require("kanagawa").setup(vim.tbl_deep_extend("force", opts, {
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    variablebuiltinStyle = { italic = true },
    specialReturn = true, -- special highlight for the return keyword
    specialException = true, -- special highlight for exception handling keywords
    transparent = false, -- do not set background color
    dimInactive = false, -- dim inactive window `:h hl-NormalNC`
    globalStatus = vim.opt.laststatus == 3, -- adjust window separators highlight for laststatus=3
}))

vim.cmd("colorscheme kanagawa")

local get_hl = require("helpers").get_hl

vim.cmd(
    "hi! LineNr"
    .. " guibg=" .. get_hl("Normal", "bg#")
    .. " guifg=" .. get_hl("Comment", "fg#")
)
vim.cmd(
    "hi! LineNrAbove"
    .. " guibg=" .. get_hl("Normal", "bg#")
    .. " guifg=" .. get_hl("Comment", "fg#")
)
vim.cmd(
    "hi! LineNrBelow"
    .. " guibg=" .. get_hl("Normal", "bg#")
    .. " guifg=" .. get_hl("Comment", "fg#")
)


vim.cmd("hi! CursorLineFold guibg=" .. get_hl("Normal", "bg#"))
vim.cmd("hi! CursorLineNr guibg=" .. get_hl("Normal", "bg#"))

vim.api.nvim_set_hl(0, "rainbowcol1", {
    fg = "#C34043",
})
vim.api.nvim_set_hl(0, "rainbowcol2", {
    fg = "#FF9E3B",
})
vim.api.nvim_set_hl(0, "rainbowcol3", {
    fg = "#98BB6C",
})
vim.api.nvim_set_hl(0, "rainbowcol4", {
    fg = "#6A9589",
})
vim.api.nvim_set_hl(0, "rainbowcol5", {
    fg = "#7E9CD8",
})
vim.api.nvim_set_hl(0, "rainbowcol6", {
    fg = "#D27E99",
})
vim.api.nvim_set_hl(0, "rainbowcol7", {
    fg = "#957FB8",
})

local blend_rgb = require("lib.color").blend_hex
local diagnostic_types = { "Error", "Warn", "Hint", "Info" }
for _, diagnostic_type in ipairs(diagnostic_types) do
    vim.cmd(
        "hi DiagnosticVirtualText"
        .. diagnostic_type
        .. " guifg="
        .. get_hl("DiagnosticVirtualText" .. diagnostic_type, "fg#")
        .. " guibg="
        .. blend_rgb(
            get_hl("Normal", "bg#"),
            get_hl("DiagnosticVirtualText" .. diagnostic_type, "fg#"),

            0.1
        )
    )
end
