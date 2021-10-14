local table_contains = require('utils.config').table_contains
local get_buf_filetype = require('utils.config').get_buf_filetype

local ts_filetypes = {
    'javascriptreact',
    'typescriptreact',
}

require('nvim_comment').setup({
    -- Linters prefer comment and line to have a space in between markers
    marker_padding = true,
    -- should comment out empty or whitespace only lines
    comment_empty = false,
    -- Should key mappings be created
    create_mappings = true,
    -- Normal mode mapping left hand side
    line_mapping = 'gcc',
    -- Visual/Operator mapping left hand side
    operator_mapping = 'gc',
    -- Hook function to call before commenting takes place
    hook = function()
        if table_contains(ts_filetypes, get_buf_filetype(0)) then
            require('ts_context_commentstring.internal').update_commentstring()
        end
    end,
})
