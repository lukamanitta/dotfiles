local lines = require("plugins.ui.heirline.lines")

require("heirline").setup({
    statusline = lines.BubbleStatusLine,
    -- tabline = lines.BubbleBufferLine,
})
