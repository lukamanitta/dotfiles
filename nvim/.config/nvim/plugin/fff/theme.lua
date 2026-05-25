vim.api.nvim_set_hl(0, "FFFSelectedActive", { link = "CursorLine" })

vim.api.nvim_set_hl(0, "FFFGitStaged", { link = "Added" })
vim.api.nvim_set_hl(0, "FFFGitSignStaged", { link = "Added" })
vim.api.nvim_set_hl(0, "FFFGitStagedSelected", {
    bg = require("h").get_hl("FFFSelectedActive", "bg#"),
    fg = require("h").get_hl("Added", "fg#"),
})
vim.api.nvim_set_hl(0, "FFFGitSignStagedSelected", {
    bg = require("h").get_hl("FFFSelectedActive", "bg#"),
    fg = require("h").get_hl("Added", "fg#"),
})

vim.api.nvim_set_hl(0, "FFFGitDeleted", { link = "Removed" })
vim.api.nvim_set_hl(0, "FFFGitSignDeleted", { link = "Removed" })
vim.api.nvim_set_hl(0, "FFFGitDeletedSelected", {
    bg = require("h").get_hl("FFFSelectedActive", "bg#"),
    fg = require("h").get_hl("Removed", "fg#"),
})
vim.api.nvim_set_hl(0, "FFFGitSignDeletedSelected", {
    bg = require("h").get_hl("FFFSelectedActive", "bg#"),
    fg = require("h").get_hl("Removed", "fg#"),
})

vim.api.nvim_set_hl(0, "FFFGitIgnored", { link = "Ignored" })
vim.api.nvim_set_hl(0, "FFFGitSignIgnored", { link = "Ignored" })
vim.api.nvim_set_hl(0, "FFFGitIgnoredSelected", {
    bg = require("h").get_hl("FFFSelectedActive", "bg#"),
    fg = require("h").get_hl("Ignored", "fg#"),
})
vim.api.nvim_set_hl(0, "FFFGitSignIgnoredSelected", {
    bg = require("h").get_hl("FFFSelectedActive", "bg#"),
    fg = require("h").get_hl("Ignored", "fg#"),
})

vim.api.nvim_set_hl(0, "FFFGitRenamed", { link = "Changed" })
vim.api.nvim_set_hl(0, "FFFGitSignRenamed", { link = "Changed" })
vim.api.nvim_set_hl(0, "FFFGitRenamedSelected", {
    bg = require("h").get_hl("FFFSelectedActive", "bg#"),
    fg = require("h").get_hl("Changed", "fg#"),
})
vim.api.nvim_set_hl(0, "FFFGitSignRenamedSelected", {
    bg = require("h").get_hl("FFFSelectedActive", "bg#"),
    fg = require("h").get_hl("Changed", "fg#"),
})

vim.api.nvim_set_hl(0, "FFFGitModified", { link = "Changed" })
vim.api.nvim_set_hl(0, "FFFGitSignModified", { link = "Changed" })
vim.api.nvim_set_hl(0, "FFFGitModifiedSelected", {
    bg = require("h").get_hl("FFFSelectedActive", "bg#"),
    fg = require("h").get_hl("Changed", "fg#"),
})
vim.api.nvim_set_hl(0, "FFFGitSignModifiedSelected", {
    bg = require("h").get_hl("FFFSelectedActive", "bg#"),
    fg = require("h").get_hl("Changed", "fg#"),
})

vim.api.nvim_set_hl(0, "FFFGitUntracked", { link = "Untracked" })
vim.api.nvim_set_hl(0, "FFFGitSignUntracked", { link = "Untracked" })
vim.api.nvim_set_hl(0, "FFFGitUntrackedSelected", {
    bg = require("h").get_hl("FFFSelectedActive", "bg#"),
    fg = require("h").get_hl("Untracked", "fg#"),
})
vim.api.nvim_set_hl(0, "FFFGitSignUntrackedSelected", {
    bg = require("h").get_hl("FFFSelectedActive", "bg#"),
    fg = require("h").get_hl("Untracked", "fg#"),
})
