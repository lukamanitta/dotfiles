-- Modified Eviline config for lualine
-- Credit: shadmansaleh
local lualine = require('lualine')

local get_hi_group_bg = require('utils.config').get_hi_group_bg
local get_hi_group_fg = require('utils.config').get_hi_group_fg

-- Color table for highlights
local colors = {
    bg = get_hi_group_bg('StatusLine'),
    fg = get_hi_group_fg('StatusLine'),
    yellow = '#ECBE7B',
    cyan = '#008080',
    darkblue = '#081633',
    green = '#98be65',
    orange = '#FF8800',
    violet = '#a9a1e1',
    magenta = '#c678dd',
    blue = '#51afef',
    red = '#ec5f67',
    filename = get_hi_group_fg('Keyword'),
    endblock = get_hi_group_fg('Title'),
}

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand('%:p:h')
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

-- Config
local config = {
    options = {
        -- Disable sections and component separators
        component_separators = '',
        section_separators = '',
        disabled_filetypes = { 'Trouble' },
        theme = 'tokyonight',
        -- theme = {
        --     -- We are going to use lualine_c an lualine_x as left and
        --     -- right section. Both are highlighted by c theme .  So we
        --     -- are just setting default looks o statusline
        --     normal = { c = { fg = colors.fg, bg = colors.bg } },
        --     inactive = { c = { fg = colors.fg, bg = colors.bg } },
        -- },
    },
    sections = {
        -- Remove defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
    },
    inactive_sections = {
        -- Remove defaults
        lualine_a = {},
        lualine_v = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
    },
    extensions = { 'nvim-tree' },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
end

-- ins_left({
--     function()
--         return '▊'
--     end,
--     color = { fg = colors.endblock }, -- Sets highlighting of component
--     left_padding = 0, -- We don't need space before this
-- })

local get_buf_icon = require('utils.config').get_buf_icon
ins_left({
    -- mode component
    function()
        -- auto change color according to neovims mode
        local mode_color = {
            n = colors.blue,
            i = colors.green,
            v = colors.red,
            [''] = colors.blue,
            V = colors.blue,
            c = colors.magenta,
            no = colors.red,
            s = colors.orange,
            S = colors.orange,
            [''] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.red,
            ce = colors.red,
            r = colors.cyan,
            rm = colors.cyan,
            ['r?'] = colors.cyan,
            ['!'] = colors.red,
            t = colors.red,
        }
        vim.api.nvim_command(
            'hi! LualineMode guifg=' .. mode_color[vim.fn.mode()] .. ' guibg=' .. colors.bg
        )
        return get_buf_icon(0)
    end,
    color = 'LualineMode',
    left_padding = 0,
})

-- ins_left({
--     -- filesize component
--     function()
--         local function format_file_size(file)
--             local size = vim.fn.getfsize(file)
--             if size <= 0 then
--                 return ''
--             end
--             local sufixes = { 'b', 'k', 'm', 'g' }
--             local i = 1
--             while size > 1024 do
--                 size = size / 1024
--                 i = i + 1
--             end
--             return string.format('%.1f%s', size, sufixes[i])
--         end
--         local file = vim.fn.expand('%:p')
--         if string.len(file) == 0 then
--             return ''
--         end
--         return format_file_size(file)
--     end,
--     condition = conditions.buffer_not_empty,
-- })

ins_left({
    'filename',
    condition = conditions.buffer_not_empty,
    color = { fg = colors.filename, bg = colors.bg, gui = 'bold' },
})

ins_left({
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = { error = ' ', warn = ' ', info = ' ' },
    color_error = colors.red,
    color_warn = colors.yellow,
    color_info = colors.cyan,
})

local gps = require('nvim-gps')
ins_left({
    gps.get_location,
    condition = gps.is_available,
})

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left({
    function()
        return '%='
    end,
})

ins_left({
    -- Lsp server name .
    function()
        local msg = 'No Active Lsp'
        local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
            return msg
        end
        for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
            end
        end
        return msg
    end,
    icon = ' LSP:',
    color = { fg = get_hi_group_fg('SignColumn'), gui = 'bold' },
})

-- Add components to right sections
ins_right({
    'branch',
    icon = '',
    condition = conditions.check_git_workspace,
    color = { fg = colors.violet, gui = 'bold' },
})

ins_right({
    'diff',
    -- Is it me or the symbol for modified us really weird
    symbols = { added = ' ', modified = '柳', removed = ' ' },
    color_added = colors.green,
    color_modified = colors.orange,
    color_removed = colors.red,
    condition = conditions.hide_in_width,
})

-- ins_right {'location'}

ins_right({ 'progress', color = { fg = colors.fg, gui = 'bold' } })

-- ins_right({
--     function()
--         return '▊'
--     end,
--     color = { fg = colors.endblock },
--     right_padding = 0,
-- })

lualine.setup(config)