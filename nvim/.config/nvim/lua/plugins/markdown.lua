local apply_globals = require('utils.config').apply_globals

apply_globals({
    vim_markdown_conceal = 2,
    vim_markdown_conceal_code_blocks = 1,
    vim_markdown_fenced_languages = vim.g.markdown_fenced_languages,
    vim_markdown_follow_anchor = 1,
    vim_markdown_math = 1,
    vim_markdown_frontmatter = 1,
    vim_markdown_strikethrough = 1,
    vim_markdown_no_extensions_in_markdown = 0,
    vim_markdown_autowrite = 1,
    vim_markdown_new_list_item_indent = 0,
    vim_markdown_auto_insert_bullets = 0,
    vim_markdown_edit_url_in = 'current',
})

vim.cmd('silent map <CR> <Plug>Markdown_EditUrlUnderCursor')
