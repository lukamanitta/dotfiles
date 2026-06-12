if vim.g.colourscheme == "Gruvbox" then
    vim.pack.add({
        { src = "https://github.com/ellisonleao/gruvbox.nvim" },
    })

    vim.cmd.colorscheme("gruvbox")

    local diagnostic_types = { "Error", "Warn", "Info", "Hint" }
    for _, severity in ipairs(diagnostic_types) do
        local hl = "DiagnosticSign" .. severity
        require("h").set_hl(
            hl,
            { fg = require("h").get_hl(hl, "fg#"), bg = "NONE" }
        )
    end

    require("ui.colourscheme_common")()
end
