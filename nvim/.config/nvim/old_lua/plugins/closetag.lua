local apply_globals = require("utils.helpers").apply_globals

apply_globals({
    closetag_html_filetypes = "xtml, jsx, svelte",

    -- This will make the list of non-closing tags self-closing in the specified files.
    closetag_xhtml_filetypes = "xhtml,jsx",

    -- This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
    closetag_emptyTags_caseSensitive = 1,

    -- Disables auto-close if not in a "valid" region (based on filetype)
    closetag_regions = {
        typescriptreact = "jsxRegion,tsxRegion",
        javascriptreact = "jsxRegion",
    },

    -- Shortcut for closing tags, default is '>'
    closetag_shortcut = ">",

    -- Add > at current position without closing the current tag, default is ''
    closetag_close_shortcut = "<leader>>",
})
