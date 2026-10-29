require("ui.theme").register(function()
    vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Normal" })
end)
