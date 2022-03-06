local get_hex = require('cokeline.utils').get_hex

vim.cmd('hi! link TabLineFill Normal')

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

    rendering = {
        max_buffer_width = 20,

        -- left_sidebar = {
        --     filetype = 'NvimTree',
        --     components = {
        --         text = 'NvimTree',
        --         hl = {
        --             fg = get_hex('Normal', 'fg'),
        --             bg = get_hex('NvimTreeNormal', 'bg'),
        --             style = 'bold',
        --         },
        --     },
        -- },
    },

    default_hl = {
        focused = {
            fg = get_hex('Normal', 'fg'),
            bg = get_hex('ColorColumn', 'bg'),
        },
        unfocused = {
            fg = get_hex('Comment', 'fg'),
            bg = get_hex('ColorColumn', 'bg'),
        },
    },

    -- A list of components to be rendered for each buffer
    components = {
        {
            text = ' ',
            hl = {
                bg = get_hex('Normal', 'bg'),
            },
        },
        {
            text = '',
            hl = {
                fg = get_hex('ColorColumn', 'bg'),
                bg = get_hex('Normal', 'bg'),
            },
        },
        {
            text = function(buffer)
                return buffer.devicon.icon
            end,
            hl = {
                fg = function(buffer)
                    return buffer.devicon.color
                end,
            },
        },
        {
            text = ' ',
        },
        {
            text = function(buffer)
                return buffer.filename .. '  '
            end,
            hl = {
                style = function(buffer)
                    return buffer.is_focused and 'bold' or nil
                end,
            },
        },
        {
            text = '',
            hl = {
                fg = get_hex('ColorColumn', 'bg'),
                bg = get_hex('Normal', 'bg'),
            },
        },
    },
})
