local U = {}

U.colorscheme = "gruvbox"

function U.pre_colorscheme_actions()
    vim.o.background = "dark"
end

function U.post_colorscheme_actions()
    vim.cmd("hi! SignColumn guibg=" .. require("helpers").get_hl("Normal", "bg#"))
end

return U
