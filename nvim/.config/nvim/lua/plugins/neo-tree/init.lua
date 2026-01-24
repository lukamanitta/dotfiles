require("neo-tree").setup({})

local background = require("h").get_hl("StatusLine", "bg#")

vim.api.nvim_set_hl(
    0,
    "NeoTreeFloatBorder",
    { bg = background, fg = background }
)
vim.api.nvim_set_hl(0, "NeoTreeFloatTitle", { bg = background })
vim.api.nvim_set_hl(0, "NeoTreeTitleBar", { bg = background, fg = background })

require("plugins.neo-tree.keybinds")
