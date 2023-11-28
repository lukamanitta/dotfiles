local components = require("plugins.ui.heirline.components")
local props = require("plugins.ui.heirline.props")
local get_hl = require("helpers").get_hl

return {
    components.SingleSpace("Normal"),

    components.BubbleThese(
        {
            direction = "right",
            end_bgs = {
                get_hl("Normal", "bg#"),
                get_hl("StatusLine", "bg#"),
            },
        },
        components.ModeIndicator,
        vim.tbl_deep_extend("force", components.RootDir, {
            hl = {
                bg = get_hl("BarHighlight", "bg#"),
                bold = true,
            },
        }),
        vim.tbl_deep_extend("force", components.GitBranch, {
            hl = {
                fg = get_hl("StatusLine", "fg#"),
                bg = get_hl("BarHighlight2", "bg#"),
                bold = true,
            },
        })
    ),
    components.GitDiff,

    --
    components.FillSpace,
    components.FileName,
    components.FillSpace,
    --

    -- vim.tbl_deep_extend("force", components.LSPDiagnosticCounts, {
    --     hl = {
    --         bg = get_hl("StatusLine", "bg#"),
    --     },
    -- }),
    components.LSPDiagnosticCounts,
    components.BubbleThese(
        {
            direction = "left",
            end_bgs = {
                get_hl("StatusLine", "bg#"),
                get_hl("Normal", "bg#"),
            },
        },
        vim.tbl_deep_extend("force", components.LSPServerName, {
            hl = {
                bg = get_hl("BarHighlight", "bg#"),
            },
        }),
        vim.tbl_deep_extend(
            "force",
            { components.CursorLocation, components.ProgressBar },
            props.mode_colour_bg(get_hl("StatusLine", "bg#"))
        )
    ),
    components.SingleSpace("Normal"),
}
