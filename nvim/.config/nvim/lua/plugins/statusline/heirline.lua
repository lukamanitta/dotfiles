local lines = require("plugins.statusline.lines")

require("heirline").setup({
    statusline = lines.BubbleStatusLine,
})
