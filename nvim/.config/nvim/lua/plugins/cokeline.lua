local get_hex = require('cokeline.utils').get_hex

vim.cmd('hi! link TabLineFill Normal')

local background = get_hex('Normal')

require('cokeline').setup({
    show_if_buffers_are_at_least = 1,
    buffers = {
        -- A function to filter out unwanted buffers. Takes a buffer table as a
        -- parameter (see the following section for more infos) and has to return
        -- either `true` or `false`.
        -- default: `false`.
        filter_valid = function(buffer)
            return true
        end,

        -- A looser version of `filter_valid`, use this function if you still
        -- want the `cokeline-{switch,focus}-{prev,next}` mappings to work for
        -- these buffers without displaying them in your bufferline.
        -- default: `false`.
        filter_visible = function(buffer)
            return true
        end,

        focus_on_delete = 'prev', -- 'prev' | 'next',
        new_buffers_position = 'last', -- 'last' | 'next',
    },

    mappings = {
        cycle_prev_next = true, --  true | false,
    },

    -- sidebar = {
    --     filetype = 'NvimTree',
    --     components = {
    --         {
    --             text = ' ',
    --             fg = get_hex('Normal', 'fg'),
    --             bg = get_hex('StatusLine', 'bg'),
    --             style = 'bold',
    --         },
    --     },
    -- },

    rendering = {
        max_buffer_width = 20,
    },

    default_hl = {
        fg = function(buffer)
            return buffer.is_focused and get_hex('Normal', 'fg') or get_hex('Comment', 'fg')
        end,
        bg = get_hex('ColorColumn', 'bg'),
    },

    -- A list of components to be rendered for each buffer
    components = {
        {
            text = ' ',
            bg = get_hex('Normal', 'bg'),
        },
        {
            text = '',
            fg = get_hex('ColorColumn', 'bg'),
            bg = get_hex('Normal', 'bg'),
        },
        {
            text = function(buffer)
                return buffer.devicon.icon
            end,
            fg = function(buffer)
                return buffer.devicon.color
            end,
        },
        {
            text = ' ',
        },
        {
            text = function(buffer)
                return buffer.filename .. '  '
            end,
            style = function(buffer)
                return buffer.is_focused and 'bold' or nil
            end,
        },
        {
            text = '',
            fg = get_hex('ColorColumn', 'bg'),
            bg = get_hex('Normal', 'bg'),
        },
    },
})
