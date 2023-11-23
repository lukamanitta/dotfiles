local cmd = vim.cmd

local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg


local float_blend = require("settings.globals").float_blend
cmd(
    "hi NeoTreeNormal guibg="
    .. get_hi_group_bg("StableNormal")
    .. "blend="
    .. float_blend
)
cmd("hi link NeoTreeNormalNC NeoTreeNormal")
cmd(
    "hi NeoTreeFloatBorder guibg="
    .. get_hi_group_bg("StableNormal")
    .. " guifg="
    .. get_hi_group_fg("NeoTreeFloatBorder")
    .. " blend="
    .. float_blend
)
cmd(
    "hi NeoTreeFloatTitle guibg="
    .. get_hi_group_bg("StableNormal")
    .. "blend="
    .. float_blend
)
cmd(
    "hi VertSplit guibg="
    .. get_hi_group_bg("StableNormal")
    .. " guifg="
    .. get_hi_group_bg("StableNormal")
    .. " blend="
    .. float_blend
)

if require("settings.globals").transparent_bg then
    local remove_hl_bg = require("utils.color.hl_groups").remove_hl_bg
    local hl_to_remove_bg = {
        "NeoTreePreview",
        "NeoTreeGitAdded",
        "NeoTreeGitModified",
        "NeoTreeGitDeleted",
        "NeoTreeGitRenamed",
        "NeoTreeSignColumn",
        "NeoTreeVertSplit",
        "NeoTreeFloatBorder",
        "NeoTreeFloatNormal",
        "NeoTreeNormalNC",
        "NeoTreeFileName",
    }

    for _, hl in ipairs(hl_to_remove_bg) do
        remove_hl_bg(hl)
    end
end

-- For colourschemes that support NvimTree but not NeoTree
-- vim.cmd([[
-- highlight! link NeoTreeDirectoryIcon NvimTreeFolderIcon
-- highlight! link NeoTreeDirectoryName NvimTreeFolderName
-- highlight! link NeoTreeSymbolicLinkTarget NvimTreeSymlink
-- highlight! link NeoTreeRootName NvimTreeRootFolder
-- highlight! link NeoTreeDirectoryName NvimTreeOpenedFolderName
-- highlight! link NeoTreeFileNameOpened NvimTreeOpenedFile
-- ]])

