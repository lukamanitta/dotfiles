if vim.g.colourscheme == "Kanagawa" then
    vim.pack.add({
        { src = "https://github.com/rebelot/kanagawa.nvim" },
    })

    require("kanagawa").setup({
        overrides = function(colors)
            local theme = colors.theme
            local makeDiagnosticColor = function(color)
                local c = require("kanagawa.lib.color")
                return {
                    fg = color,
                    bg = c(color):blend(theme.ui.bg, 0.95):to_hex(),
                }
            end

            return {
                DiagnosticVirtualTextHint = makeDiagnosticColor(
                    theme.diag.hint
                ),
                DiagnosticVirtualTextInfo = makeDiagnosticColor(
                    theme.diag.info
                ),
                DiagnosticVirtualTextWarn = makeDiagnosticColor(
                    theme.diag.warning
                ),
                DiagnosticVirtualTextError = makeDiagnosticColor(
                    theme.diag.error
                ),
                TelescopeTitle = { fg = theme.ui.special, bold = true },
                TelescopePromptNormal = { bg = theme.ui.bg_p1 },
                TelescopePromptBorder = {
                    fg = theme.ui.bg_p1,
                    bg = theme.ui.bg_p1,
                },
                TelescopeResultsNormal = {
                    fg = theme.ui.fg_dim,
                    bg = theme.ui.bg_m1,
                },
                TelescopeResultsBorder = {
                    fg = theme.ui.bg_m1,
                    bg = theme.ui.bg_m1,
                },
                TelescopePreviewNormal = { bg = theme.ui.bg_dim },
                TelescopePreviewBorder = {
                    bg = theme.ui.bg_dim,
                    fg = theme.ui.bg_dim,
                },
            }
        end,
    })

    vim.cmd.colorscheme("kanagawa")
    -- require("h").set_hl("SignColumn", { link = "Normal" })
    -- require("h").set_hl("ColorColumn", { link = "Normal" })
    -- require("h").set_hl("LineNr", {
    --     bg = require("h").get_hl("Normal", "bg#"),
    --     fg = require("h").get_hl("LineNr", "fg#"),
    -- })
    --
    -- require("h").set_hl("TreesitterContextLineNumber", { link = "LineNr" })
    -- require("h").set_hl("TreeSitterContextSeparator", { link = "Comment" })

    local git_sign_type = { "Add", "Change", "Delete" }
    for _, type in ipairs(git_sign_type) do
        local hl = "GitSigns" .. type
        local mini_hl = "MiniDiffSign" .. type
        require("h").mod_hl(hl, { bg = "NONE" })
        require("h").mod_hl(mini_hl, { bg = "NONE" })
    end

    require("ui.colourscheme_common")()
end
