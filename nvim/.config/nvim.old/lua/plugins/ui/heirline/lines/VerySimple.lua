local components = require("plugins.ui.heirline.components")
local get_hl = require("helpers").get_hl

return {
    components.SingleSpace("Normal"),

    components.Semicircle("left", {
        hl = {
            fg = get_hl("StatusLine", "bg#"),
            bg = get_hl("Normal", "bg#"),
        },
    }),

    components.GitDiff,

    components.FillSpace,

    components.FileName,

    components.FillSpace,

    vim.tbl_deep_extend("force", components.LSPDiagnosticCounts, {
        hl = {
            bg = get_hl("StatusLine", "bg#"),
        },
    }),

    components.Semicircle("right", {
        hl = {
            fg = get_hl("StatusLine", "bg#"),
            bg = get_hl("Normal", "bg#"),
        },
    }),

    components.SingleSpace("Normal"),
}
