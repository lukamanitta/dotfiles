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
        java = { 'uncrustify' },
        sh = { 'shfmt' },
        rust = { 'rustfmt' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
    },
    ale_lua_stylua_options = '--config-path ~/.config/nvim/.stylua.toml',
    ale_c_uncrustify_options = '-c ~/uncrustify.cfg --no-backup',
    ale_c_clangformat_options = '-style= ~/.clang-format',
})
