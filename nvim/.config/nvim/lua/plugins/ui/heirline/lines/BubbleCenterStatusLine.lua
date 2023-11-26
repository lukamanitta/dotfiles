local components = require("plugins.heirline.components")
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg
local props = require("plugins.heirline.props")

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
                    bg = get_hi_group_bg("BarHighlight"),
                    fg = get_hi_group_fg("StatusLine"),
                },
            }
        -- props.mode_colour_bg(get_hi_group_bg("StatusLine"))
        ),
        { get_hi_group_bg("Normal") }
    ),
    vim.tbl_deep_extend("force", components.FillSpace, {
        hl = "Normal",
    }),
}
