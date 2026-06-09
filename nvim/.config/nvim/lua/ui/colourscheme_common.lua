vim.api.nvim_set_hl(0, "Added", { link = "DiagnosticOk" })
vim.api.nvim_set_hl(0, "Modified", { link = "DiagnosticHint" })
vim.api.nvim_set_hl(0, "Removed", { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "Unstaged", { link = "DiagnosticWarn" })
vim.api.nvim_set_hl(0, "Ignored", { link = "Comment" })

vim.api.nvim_set_hl(0, "Float", { link = "StatusLine" })
vim.api.nvim_set_hl(0, "NormalFloat", { link = "StatusLine" })
vim.api.nvim_set_hl(0, "FloatBorder", { link = "StatusLine" })
