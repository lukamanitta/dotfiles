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
    U.set_hl("ColorColumn", { link = "Normal" })
    U.set_hl("LineNr", {
        bg = U.get_hl("Normal", "bg#"),
        fg = U.get_hl("LineNr", "fg#"),
    })
    U.set_hl("LineNrAbove", { link = "LineNr" })
    U.set_hl("LineNrBelow", { link = "LineNr" })

    U.set_hl("TreesitterContextLineNumber", { link = "LineNr" })
    U.set_hl("TreesitterContextSeparator", { link = "Comment" })
end
