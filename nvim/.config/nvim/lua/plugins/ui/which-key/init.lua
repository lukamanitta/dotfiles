local general_icons = require("icons").general

require("which-key").setup({
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
    },
})

require("plugins.ui.which-key.custom_hl")


