require('trouble').setup({
    position = 'right',
    height = 10,
    width = 40,
    icons = true,
    mode = 'lsp_workspace_diagnostics',
    fold_open = '',
    fold_closed = '',
    action_keys = {
        close = 'q',
        cancel = '<esc>', -- cancel the preview and get back to your last window / buffer / cursor
        refresh = 'r',
        jump = { '<cr>', '<tab>' },
        open_split = { '<c-x>' },
        open_vsplit = { '<c-v>' },
        open_tab = { '<c-t>' },
        jump_close = { 'o' }, -- jump to the diagnostic and close the list
        toggle_mode = 'm', -- toggle between "workspace" and "document" diagnostics mode
        toggle_preview = 'P', -- toggle auto_preview
        hover = 'K', -- opens a small popup with the full multiline message
        preview = 'p', -- preview the diagnostic location
        close_folds = { 'zM', 'zm' }, -- close all folds
        open_folds = { 'zR', 'zr' }, -- open all folds
        toggle_fold = { 'zA', 'za' }, -- toggle fold of current file
        previous = 'k', -- preview item
        next = 'j', -- next item
    },
    indent_lines = false, -- add an indent guide below the fold icons
    auto_open = true, -- automatically open the list when you have diagnostics
    auto_close = true, -- automatically close the list when you have no diagnostics
    auto_preview = false, -- automatically preview the location of the diagnostic
    auto_fold = false, -- automatically fold a file trouble list at creation
    signs = {
        error = '',
        warning = '',
        hint = '',
        information = '',
        other = '﫠',
    },
    use_lsp_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
})
