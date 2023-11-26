-- TODO: setup this plugin
local lines = require("plugins.heirline.lines")

require("heirline").setup({
    statusline = lines.BubbleStatusLine,
})
