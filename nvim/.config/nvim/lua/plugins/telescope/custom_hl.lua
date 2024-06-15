local get_hl = require("helpers").get_hl

local prompt_bg = get_hl("StatusLineNC", "bg#")
local other_bg_hl_group = "StatusLine"

-- Normal

vim.cmd(
    "hi! TelescopePromptNormal guibg="
        .. prompt_bg
        .. " guifg="
        .. get_hl("Normal", "fg#")
        .. "cterm=NONE"
)
vim.cmd("hi! link TelescopeResultsNormal " .. other_bg_hl_group)
vim.cmd("hi! link TelescopePreviewNormal " .. other_bg_hl_group)

-- Borders

vim.cmd(
    "hi! TelescopePromptBorder guibg="
        .. prompt_bg
        .. " guifg="
        .. get_hl("Normal", "fg#")
        .. "cterm=NONE"
)
vim.cmd("hi! link TelescopeResultsBorder " .. other_bg_hl_group)
vim.cmd("hi! link TelescopePreviewBorder " .. other_bg_hl_group)
vim.cmd("hi! link TelescopeBorder Normal")

-- Titles

vim.cmd(
    "hi! TelescopePromptTitle guibg="
        .. prompt_bg
        .. " guifg="
        .. get_hl("Normal", "fg#")
        .. "cterm=NONE"
)
vim.cmd("hi! link TelescopeResultsTitle " .. other_bg_hl_group)
vim.cmd("hi! link TelescopePreviewTitle " .. other_bg_hl_group)
vim.cmd("hi! link TelescopeTitle StatusLine")

-- Selection Caret & Search Icon

local caret_colour = get_hl("TelescopeSelectionCaret", "fg#")
vim.cmd("hi! TelescopeSelectionCaret guifg=" .. caret_colour .. " guibg=NONE")
vim.cmd("hi! TelescopePromptPrefix guifg=" .. caret_colour .. " guibg=NONE")
