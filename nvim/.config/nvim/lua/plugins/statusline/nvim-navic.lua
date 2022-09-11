require("nvim-navic").setup({
    icons = require("assets.icons").types,
    highlight = true,
    separator = " " .. require("assets.icons").general.CaretRight .. " ",
    depth_limit = 5,
    depth_limit_indicator = " "
        .. require("assets.icons").general.DotsHorizontal
        .. " ",
})
