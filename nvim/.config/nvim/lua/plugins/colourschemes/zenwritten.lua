vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "zenwritten",
    callback = function()
        local lush = require("lush")
        local base = require("zenwritten")
        local specs = lush.parse(function()
            return {
                ---@diagnostic disable-next-line: undefined-global
                LspInlayHint({
                    fg = base.LspInlayHint.fg,
                    bg = base.Normal.bg,
                    gui = "italic",
                }),
            }
        end)
        lush.apply(lush.compile(specs))
    end,
})
vim.cmd.colorscheme("zenwritten")
