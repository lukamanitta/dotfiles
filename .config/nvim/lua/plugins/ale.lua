local apply_globals = require('utils.config').apply_globals

apply_globals({
    ale_disable_lsp = 1,
    ale_sign_column_always = 1,
    ale_fix_on_save = 1,
    ale_sign_error = '',
    ale_sign_warning = '',
    ale_fixers = {
        ['*'] = { 'remove_trailing_lines', 'trim_whitespace' },
        javascript = { 'eslint' },
        javascriptreact = { 'eslint' },
        lua = { 'stylua' },
        java = { 'javac' },
        sh = { 'shellcheck' },
        rust = { 'rustfmt' },
    },
    ale_lua_stylua_options = '--search-parent-directories',
})
