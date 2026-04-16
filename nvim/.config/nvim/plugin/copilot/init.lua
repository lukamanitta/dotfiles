vim.pack.add({
    { src = "https://github.com/github/copilot.vim" }
})

require("h").overwrite_keys(vim.g, {
    copilot_no_tab_map = true,
    copilot_assume_mapped = true,
    -- copilot_filetypes = { rust = false },
})
