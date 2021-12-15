local apply_globals = require('utils.config').apply_globals

apply_globals({
    vim_markdown_conceal = 1,
    vim_markdown_conceal_code_blocks = 1,
    vim_markdown_follow_anchor = 1,
    vim_markdown_math = 1,
    vim_markdown_no_extensions_in_markdown = 1,
    vim_markdown_autowrite = 1,
    vim_markdown_auto_insert_bullets = 1,
    vim_markdown_edit_url_in = 'current',
})
