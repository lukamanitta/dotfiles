vim.pack.add({
    {
        src = "https://github.com/rcarriga/nvim-notify",
    }
})

require("notify").setup({
    fps = 60,
    timeout = 3000,
})
vim.notify = require("notify")
