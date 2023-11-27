local cmd = vim.cmd

local get_hl = require("helpers").get_hl

local background = get_hl("StatusLine", "bg#")

cmd(
    "hi NeoTreeNormal guibg="
    .. background
)
cmd("hi link NeoTreeNormalNC NeoTreeNormal")
cmd(
    "hi NeoTreeFloatBorder guibg="
    .. background
    .. " guifg="
    .. background
)
cmd(
    "hi NeoTreeFloatTitle guibg="
    .. background
)
cmd(
    "hi VertSplit guibg="
    .. background
    .. " guifg="
    .. background
)

-- For colourschemes that support NvimTree but not NeoTree
-- vim.cmd([[
-- highlight! link NeoTreeDirectoryIcon NvimTreeFolderIcon
-- highlight! link NeoTreeDirectoryName NvimTreeFolderName
-- highlight! link NeoTreeSymbolicLinkTarget NvimTreeSymlink
-- highlight! link NeoTreeRootName NvimTreeRootFolder
-- highlight! link NeoTreeDirectoryName NvimTreeOpenedFolderName
-- highlight! link NeoTreeFileNameOpened NvimTreeOpenedFile
-- ]])

