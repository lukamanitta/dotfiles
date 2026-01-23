require("h").overwrite_keys(vim.g, {
    copilot_no_tab_map = true,
    copilot_assume_mapped = true,
    -- copilot_filetypes = { rust = false },
})

require("plugins.copilot.keybinds")
