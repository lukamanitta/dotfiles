if vim.g.colourscheme == "gruvbox" then
    vim.pack.add({
        { src = "https://github.com/ellisonleao/gruvbox.nvim" }
    })

    vim.cmd.colorscheme("gruvbox")

    vim.api.nvim_set_hl(0, "SignColumn", { link = "Normal" })

    local diagnostic_types = { "Error", "Warn", "Info", "Hint" }
    for _, severity in ipairs(diagnostic_types) do
        local hl = "DiagnosticSign" .. severity
        vim.api.nvim_set_hl(
            0,
            hl,
            { fg = require("h").get_hl(hl, "fg#"), bg = "NONE" }
        )
    end
end
