require('mkdnflow').setup({
    default_mappings = true,
    create_dirs = true,
    links_relative_to = 'current', -- 'first' (first opened file) | 'current'
    filetypes = { md = true, rmd = true, markdown = true },
    new_file_prefix = '',
    evaluate_prefix = false,
    wrap_to_beginning = true,
    wrap_to_end = true,
})
