local cmd = vim.cmd
local get_hi_group_bg = require("utils.config").get_hi_group_bg
local general_icons = require("assets.icons").general

require("trouble").setup({
    position = "bottom",
    height = 8,
    width = 40,
    icons = true,
    mode = "workspace_diagnostics",
    fold_open = "",
    fold_closed = "",
    action_keys = {
        close = "q",
        cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
        refresh = "r",
        jump = { "<cr>", "<tab>" },
        open_split = { "<c-x>" },
        open_vsplit = { "<c-v>" },
        open_tab = { "<c-t>" },
        jump_close = { "o" }, -- jump to the diagnostic and close the list
        toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
        toggle_preview = "P", -- toggle auto_preview
        hover = "K", -- opens a small popup with the full multiline message
        preview = "p", -- preview the diagnostic location
        close_folds = { "zM", "zm" }, -- close all folds
        open_folds = { "zR", "zr" }, -- open all folds
        toggle_fold = { "zA", "za" }, -- toggle fold of current file
        previous = "k", -- preview item
        next = "j", -- next item
    },
    indent_lines = false, -- add an indent guide below the fold icons
    auto_open = false, -- automatically open the list when you have diagnostics
    auto_close = true, -- automatically close the list when you have no diagnostics
    auto_preview = false, -- automatically preview the location of the diagnostic
    auto_fold = false, -- automatically fold a file trouble list at creation
    signs = {
        other = general_icons.CheckCircle,
    },
    use_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
})
cmd("hi! link TroubleNormal StatusLine")

cmd("hi! TroubleText guibg=NONE")
cmd("hi! TroubleTextHint guibg=NONE")
cmd("hi! TroubleTextWarning guibg=NONE")
cmd("hi! TroubleTextError guibg=NONE")
cmd("hi! TroubleTextInformation guibg=NONE")
cmd("hi! TroubleCount guibg=NONE")
cmd("hi! TroubleFoldIcon guibg=NONE")
