local background = require("h").get_hl("StatusLine", "bg#")

vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = background })
vim.api.nvim_set_hl(
    0,
    "NeoTreeFloatBorder",
    { bg = background, fg = background }
)
vim.api.nvim_set_hl(0, "NeoTreeFloatTitle", { bg = background })
vim.api.nvim_set_hl(0, "NeoTreeTitleBar", { bg = background, fg = background })
