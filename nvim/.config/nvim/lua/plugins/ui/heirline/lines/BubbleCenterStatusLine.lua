local components = require("plugins.ui.heirline.components")
local get_hl = require("helpers").get_hl
local props = require("plugins.ui.heirline.props")

return {
    vim.tbl_deep_extend("force", components.FillSpace, {
        hl = "Normal",
    }),
    components.BubbleThis(
        vim.tbl_deep_extend(
            "force",
            components.FileName,
            {
                hl = {
                    bg = get_hl("BarHighlight", "bg#"),
                    fg = get_hl("StatusLine", "bg#"),
                },
            }
        -- props.mode_colour_bg(get_hl("StatusLine", "bg#"))
        ),
        { get_hl("Normal", "bg#") }
    ),
    vim.tbl_deep_extend("force", components.FillSpace, {
        hl = "Normal",
    }),
}
