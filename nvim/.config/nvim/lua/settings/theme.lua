local U = {}

function U.pre_colorscheme()
    vim.o.background = "dark"
end

function U.post_colorscheme()
    vim.cmd("hi! SignColumn guibg=" .. require("helpers").get_hl("Normal", "bg#"))
end

return U
