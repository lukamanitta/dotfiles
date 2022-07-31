local cmd = vim.cmd

require("kanagawa").setup({
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    variablebuiltinStyle = { italic = true },
    specialReturn = true, -- special highlight for the return keyword
    specialException = true, -- special highlight for exception handling keywords
    transparent = false, -- do not set background color
    dimInactive = false, -- dim inactive window `:h hl-NormalNC`
    globalStatus = vim.opt.laststatus == 3, -- adjust window separators highlight for laststatus=3
    colors = {
        bg_light0 = "#16161d",
    },
    overrides = {},
})

cmd("set background=dark")
cmd("colorscheme kanagawa")

cmd("hi link NvimTreeNormalNC NvimTreeNormal")
