local random_range = require("utils.math").random_range
local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local multiply_hex_brightness = require("utils.color").multiply_hex_brightness
local Set = require("utils.collections.Set")

local prefix_caret_colour =
get_hi_group_fg("rainbowcol" .. random_range(1, 7, os.time()))

-- Selection Caret & Search Icon
vim.cmd(
    "hi! TelescopeSelectionCaret guifg=" .. prefix_caret_colour .. " guibg=NONE"
)
vim.cmd(
    "hi! TelescopePromptPrefix guifg=" .. prefix_caret_colour .. " guibg=NONE"
)

if require("settings.globals").float_style == "classic" then
    vim.cmd("hi! link TelescopeBorder FloatBorder")
    vim.cmd("hi! link TelescopeTitle FloatBorder")

    local pane_types = {
        "TelescopePrompt",
        "TelescopeResults",
        "TelescopePreview",
    }

    local available_colours = Set:new({ 1, 2, 3, 4, 5, 6 })

    for _, pane in ipairs(pane_types) do
        local random_num = random_range(1, available_colours:size())
        local colour = available_colours:at(random_num)
        vim.cmd(
            "hi "
            .. pane
            .. "Border"
            .. " guibg=NONE"
            .. " guifg="
            .. get_hi_group_fg("rainbowcol" .. colour)
        )
        vim.cmd(
            "hi "
            .. pane
            .. "Title"
            .. " guibg=NONE"
            .. " guifg="
            .. get_hi_group_fg("rainbowcol" .. colour)
        )
        available_colours:remove(colour)

        for _, pane_normal in ipairs(pane_types) do
            require("utils.color.hl_groups").remove_hl_bg(
                pane_normal .. "Normal"
            )
        end
    end
elseif require("settings.globals").float_style == "flat" then
    local normal_background =
    multiply_hex_brightness(get_hi_group_bg("StableNormal"), 0.3)

    -- Normal
    vim.cmd(
        "hi! TelescopePromptNormal guibg="
        .. normal_background
        .. " guifg="
        .. get_hi_group_fg("Normal")
    )
    vim.cmd("hi! link TelescopeResultsNormal StatusLine")
    vim.cmd("hi! link TelescopePreviewNormal StatusLine")

    -- Borders
    vim.cmd(
        "hi! TelescopePromptBorder guibg="
        .. normal_background
        .. " guifg="
        .. get_hi_group_fg("Normal")
    )
    vim.cmd("hi! link TelescopeResultsBorder StatusLine")
    vim.cmd("hi! link TelescopePreviewBorder StatusLine")
    vim.cmd("hi! link TelescopeBorder Normal")

    -- Titles
    vim.cmd(
        "hi! TelescopePromptTitle guibg="
        .. normal_background
        .. " guifg="
        .. get_hi_group_fg("Normal")
    )
    vim.cmd("hi! link TelescopeResultsTitle Normal")
    vim.cmd("hi! link TelescopePreviewTitle Normal")
    vim.cmd("hi! link TelescopeTitle StatusLine")
end
