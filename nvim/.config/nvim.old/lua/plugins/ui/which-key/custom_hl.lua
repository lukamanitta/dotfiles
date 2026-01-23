local get_hl = require("helpers").get_hl
vim.cmd("hi WhichKeyFloat guibg=" .. get_hl("StatusLine", "bg#"))
