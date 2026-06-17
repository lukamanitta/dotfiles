if vim.g.colourscheme == "Mini Base16" then
    vim.pack.add({
        { src = "https://github.com/nvim-mini/mini.base16" },
    })

    require("mini.base16").setup({
        palette = require("ui.palettes.colourme"),
    })

    require("h").set_hl("StatusLine", { link = "StatusLineNC" })

    local diagnostic_types = { "Error", "Warn", "Info", "Hint" }
    for _, severity in ipairs(diagnostic_types) do
        local hl = "DiagnosticSign" .. severity
        require("h").set_hl(
            hl,
            { fg = require("h").get_hl(hl, "fg#"), bg = "NONE" }
        )
    end

    local git_sign_type = { "Add", "Change", "Delete" }
    for _, type in ipairs(git_sign_type) do
        local hl = "GitSigns" .. type
        local mini_hl = "MiniDiffSign" .. type
        require("h").mod_hl(hl, { bg = "NONE" })
        require("h").mod_hl(mini_hl, { bg = "NONE" })
    end

    require("ui.colourscheme_common")()
end
