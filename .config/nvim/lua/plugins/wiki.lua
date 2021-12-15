local apply_globals = require('utils.config').apply_globals

apply_globals({
    wiki_root = '~/notes',
    wiki_filetypes = { 'md' },
    wiki_link_extension = '',
    wiki_link_target_type = 'md',
})
