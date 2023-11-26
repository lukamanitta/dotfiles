local components = require("plugins.heirline.components")
local props = require("plugins.heirline.props")
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg

return {
    components.SingleSpace("Normal"),

    components.BubbleThese(
        {
            direction = "right",
            end_bgs = {
                get_hi_group_bg("Normal"),
                get_hi_group_bg("StatusLine"),
            },
        },
        components.ModeIndicator,
        vim.tbl_deep_extend("force", components.RootDir, {
            hl = {
                bg = get_hi_group_bg("BarHighlight"),
                bold = true,
            },
        }),
        vim.tbl_deep_extend("force", components.GitBranch, {
            hl = {
                fg = get_hi_group_bg("BarAccent"),
                bg = get_hi_group_bg("BarHighlight2"),
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

    vim.tbl_deep_extend("force", components.LSPDiagnosticCounts, {
        hl = {
            bg = get_hi_group_bg("StatusLine"),
        },
    }),
    components.BubbleThese(
        {
            direction = "left",
            end_bgs = {
                get_hi_group_bg("StatusLine"),
                get_hi_group_bg("Normal"),
            },
        },
        vim.tbl_deep_extend("force", components.LSPServerName, {
            hl = {
                bg = get_hi_group_bg("BarHighlight"),
            },
        }),
        vim.tbl_deep_extend(
            "force",
            { components.CursorLocation, components.ProgressText },
            props.mode_colour_bg(get_hi_group_bg("StatusLine"))
        )
    ),
    components.SingleSpace("Normal"),
}
