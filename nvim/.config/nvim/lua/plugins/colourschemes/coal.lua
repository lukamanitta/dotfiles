require("coal").setup({
    colors = {},
})

vim.api.nvim_set_hl(0, "LspInlayHint", { link = "Comment" })
vim.api.nvim_set_hl(0, "@function", { bold = true })
vim.api.nvim_set_hl(0, "@function.builtin", { bold = true })
vim.api.nvim_set_hl(0, "@method", { bold = true })
vim.api.nvim_set_hl(0, "@none", { link = "Comment" })

local status_colours = {
    ok = "#2e9969",
    hint = "#33919c",
    info = "#6179c2",
    warn = "#b38d59",
    error = "#cc5d4b",
}

-- Diagnostic Colours
vim.api.nvim_set_hl(0, "DiagnosticOk", { fg = status_colours.ok })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = status_colours.hint })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = status_colours.info })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = status_colours.warn })
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = status_colours.error })

vim.api.nvim_set_hl(0, "OkMsg", { fg = status_colours.ok })
vim.api.nvim_set_hl(0, "WarningMsg", { fg = status_colours.hint })
vim.api.nvim_set_hl(0, "ErrorMsg", { fg = status_colours.error })
