local lines = require("plugins.ui.heirline.lines")

require("heirline").setup({
    statusline = lines.BubbleStatusLine,
    -- tabline = {lines.BubbleBufferLine},
})

-- vim.o.showtabline = 2
-- vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
