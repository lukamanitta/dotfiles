local get_hl = require("helpers").get_hl

-- Normal

vim.cmd(
    "hi! TelescopePromptNormal guibg=" 
        .. get_hl("StatusLine", "bg#") 
        .. " guifg=" 
        .. get_hl("Normal", "fg#")
        .. "cterm=NONE"
)
vim.cmd("hi! link TelescopeResultsNormal StatusLineNC")
vim.cmd("hi! link TelescopePreviewNormal StatusLineNC")

-- Borders

vim.cmd(
    "hi! TelescopePromptBorder guibg="
        .. get_hl("StatusLine", "bg#")
        .. " guifg="
        .. get_hl("Normal", "fg#")
        .. "cterm=NONE"
)
vim.cmd("hi! link TelescopeResultsBorder StatusLineNC")
vim.cmd("hi! link TelescopePreviewBorder StatusLineNC")
vim.cmd("hi! link TelescopeBorder Normal")

-- Titles

vim.cmd(
    "hi! TelescopePromptTitle guibg="
        .. get_hl("StatusLine", "bg#")
        .. " guifg="
        .. get_hl("Normal", "fg#")
        .. "cterm=NONE"
)
vim.cmd("hi! link TelescopeResultsTitle StatusLineNC")
vim.cmd("hi! link TelescopePreviewTitle StatusLineNC")
vim.cmd("hi! link TelescopeTitle StatusLine")

-- Selection Caret & Search Icon

local caret_colour = get_hl("TelescopeSelectionCaret", "fg#")
vim.cmd("hi! TelescopeSelectionCaret guifg=" .. caret_colour .. " guibg=NONE")
vim.cmd("hi! TelescopePromptPrefix guifg=" .. caret_colour .. " guibg=NONE")
