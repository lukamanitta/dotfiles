vim.loader.enable()

-- vim.opt.packpath:append(vim.fn.stdpath("data") .. "/site")
vim.cmd("set packpath=" .. vim.fn.stdpath("data") .. "/site")

require("settings")
require("ui")
-- require("plugins")
require("lsp")

-- require("vim._core.ui2").enable()
