local lsp_icons = require("icons").lsp
local general_icons = require("icons").general

vim.notify = require("notify")

require("notify").setup({
    fps = 60,

    stages = "slide",

    level = 2,
    minimum_width = 40,
    render = "default",

    timeout = 3000,

    background_colour = "Normal",

    icons = {
        ERROR = lsp_icons.Error,
        WARN = lsp_icons.Warn,
        INFO = lsp_icons.Info,
        DEBUG = general_icons.Bug,
        TRACE = general_icons.Pencil,
    },
})

-- require("plugins.plugin.custom_hl")
-- require("plugins.plugin.keybinds")
