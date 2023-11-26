local components = require("plugins.heirline.components")
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg

return {
    components.SingleSpace("Normal"),

    components.Semicircle("left", {
        hl = {
            fg = get_hi_group_bg("StatusLine"),
            bg = get_hi_group_bg("Normal"),
        },
    }),

    components.GitDiff,

    components.FillSpace,

    components.FileName,

    components.FillSpace,

    vim.tbl_deep_extend("force", components.LSPDiagnosticCounts, {
        hl = {
            bg = get_hi_group_bg("StatusLine"),
        },
    }),

    components.Semicircle("right", {
        hl = {
            fg = get_hi_group_bg("StatusLine"),
            bg = get_hi_group_bg("Normal"),
        },
    }),

    components.SingleSpace("Normal"),
}
