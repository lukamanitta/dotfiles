local get_hl = require("helpers").get_hl

vim.cmd(
    "hi! TreesitterContext guibg="
        .. get_hl("Normal", "bg#")
        .. " guifg="
        .. get_hl("TreesitterContext", "fg#")
)

vim.cmd(
    "hi! TreesitterContextSeparator guifg="
        .. get_hl("Comment", "fg#")
        .. " guibg="
        .. get_hl("TreesitterContext", "bg#")
)

vim.cmd(
    "hi! TreesitterContextLineNumber guifg="
        .. get_hl("TreesitterContextLineNumber", "fg#")
        .. " guibg="
        .. get_hl("TreesitterContext", "bg#")
)
