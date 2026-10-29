local U = require("h")

return function()
    U.set_hl("Added", { link = "DiagnosticOk" })
    U.set_hl("Modified", { link = "DiagnosticHint" })
    U.set_hl("Removed", { link = "DiagnosticError" })
    U.set_hl("Unstaged", { link = "DiagnosticWarn" })
    U.set_hl("Untracked", { link = "DiagnosticWarn" })
    U.set_hl("Ignored", { link = "Comment" })

    U.set_hl("Float", { link = "StatusLine" })
    U.set_hl("NormalFloat", { link = "StatusLine" })
    U.set_hl("FloatBorder", {
        fg = U.get_hl("StatusLine", "bg#"),
        bg = U.get_hl("StatusLine", "bg#"),
    })

    U.set_hl("SignColumn", { link = "Normal" })

    local normal_bg = U.get_hl("Normal", "bg#")
    local colorcolumn_bg = U.get_hl("CursorLine", "bg#")
    if colorcolumn_bg == "" or colorcolumn_bg == normal_bg then
        colorcolumn_bg = U.get_hl("Visual", "bg#")
    end

    if colorcolumn_bg ~= "" then
        U.set_hl("ColorColumn", { bg = colorcolumn_bg })
    else
        U.set_hl("ColorColumn", { link = "Visual" })
    end

    U.set_hl("LineNr", {
        bg = U.get_hl("Normal", "bg#"),
        fg = U.get_hl("LineNr", "fg#"),
    })
    U.set_hl("LineNrAbove", { link = "LineNr" })
    U.set_hl("LineNrBelow", { link = "LineNr" })

    U.set_hl("TreesitterContextLineNumber", { link = "LineNr" })
    U.set_hl("TreesitterContextSeparator", { link = "Comment" })
end
