return function()
    require("h").set_hl("Added", { link = "DiagnosticOk" })
    require("h").set_hl("Modified", { link = "DiagnosticHint" })
    require("h").set_hl("Removed", { link = "DiagnosticError" })
    require("h").set_hl("Unstaged", { link = "DiagnosticWarn" })
    require("h").set_hl("Untracked", { link = "DiagnosticWarn" })
    require("h").set_hl("Ignored", { link = "Comment" })

    require("h").set_hl("Float", { link = "StatusLine" })
    require("h").set_hl("NormalFloat", { link = "StatusLine" })
    require("h").set_hl("FloatBorder", {
        fg = require("h").get_hl("StatusLine", "bg#"),
        bg = require("h").get_hl("StatusLine", "bg#"),
    })

    require("h").set_hl("SignColumn", { link = "Normal" })
    require("h").set_hl("ColorColumn", { link = "Normal" })
    require("h").set_hl("LineNr", {
        bg = require("h").get_hl("Normal", "bg#"),
        fg = require("h").get_hl("LineNr", "fg#"),
    })
    require("h").set_hl("LineNrAbove", { link = "LineNr" })
    require("h").set_hl("LineNrBelow", { link = "LineNr" })

    require("h").set_hl("TreesitterContextLineNumber", { link = "LineNr" })
    require("h").set_hl("TreeSitterContextSeparator", { link = "Comment" })
end
