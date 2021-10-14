require('lspsaga').init_lsp_saga({
    use_saga_diagnostic_sign = false,
    code_action_icon = ' ',
    code_action_prompt = {
        enable = true,
        sign = true,
        sign_priority = 20,
        virtual_text = true,
    },
    code_action_keys = {
        quit = 'q',
        exec = '<CR>',
    },
    rename_prompt_prefix = '',
    rename_action_keys = {
        quit = '<Esc>', -- Can be a table
        exec = '<CR>',
    },
    border_style = 'round',
})
