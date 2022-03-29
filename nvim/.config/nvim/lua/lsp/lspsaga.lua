local lspIcons = require("assets.icons").lsp
local generalIcons = require("assets.icons").general

require("lspsaga").init_lsp_saga({
    use_saga_diagnostic_sign = false,
    code_action_icon = lspIcons.CodeAction,
    code_action_prompt = {
        enable = false,
        sign = false,
        sign_priority = 20,
        virtual_text = true,
    },
    code_action_keys = {
        quit = "<Esc>",
        exec = "<CR>",
    },
    rename_prompt_prefix = generalIcons.CaretRight,
    rename_action_keys = {
        quit = "<Esc>", -- Can be a table
        exec = "<CR>",
    },
    border_style = "round", -- single | double | round | plus
})
vim.cmd("hi! link LspFloatWinNormal Normal")
