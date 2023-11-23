-- require("plugin").setup({})
require("helpers").set_scope_opts(vim.g, {
    copilot_no_tab_map = true,
    copilot_assume_mapped = true,
})

-- require("plugins.plugin").custom_hl
require("plugins.copilot.keybinds")
