local background = require("h").get_hl("StatusLine", "bg#")
local prompt_background = require("h").get_hl("StatusLineNC", "bg#")

vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = background })
vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = prompt_background })
vim.api.nvim_set_hl(
    0,
    "TelescopePromptBorder",
    { bg = prompt_background, fg = prompt_background }
)
