require('zettelkasten').setup({
    opts = {
        notes_path = vim.fn.expand('$NOTES_DIR'),
        preview_command = '',
        browseformat = '%f - %h [%r Refs] %t',
    },
})
