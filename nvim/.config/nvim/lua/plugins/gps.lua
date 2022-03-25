local comp_icons = require('assets.icons').comp_types
local general_icons = require('assets.icons').general

require('nvim-gps').setup({
    icons = {
        ['class-name'] = comp_icons.Class .. ' ', -- Classes and class-like objects
        ['function-name'] = comp_icons.Function .. ' ', -- Functions
        ['method-name'] = comp_icons.Method .. ' ', -- Methods (functions inside class-like objects)
        ['container-name'] = comp_icons.Struct .. ' ', -- Containers (example: lua tables)
        ['tag-name'] = comp_icons.Tag .. ' ', -- Tags (example: html tags)
    },

    languages = {
        -- Some languages have custom icons
        ['json'] = {
            icons = {
                ['array-name'] = comp_icons.Array .. ' ',
                ['object-name'] = comp_icons.Object .. ' ',
                ['string-name'] = comp_icons.String .. ' ',
                ['number-name'] = comp_icons.Value .. ' ',
                ['boolean-name'] = comp_icons.Boolean .. ' ',
                ['null-name'] = comp_icons.Null .. ' ',
            },
        },
        ['toml'] = {
            icons = {
                ['table-name'] = comp_icons.Object .. ' ',
                ['array-name'] = comp_icons.Array .. ' ',
                ['string-name'] = comp_icons.String .. ' ',
                ['number-name'] = comp_icons.Value .. ' ',
                ['boolean-name'] = comp_icons.Boolean .. ' ',
                ['null-name'] = comp_icons.Null .. ' ',
                ['date-name'] = comp_icons.Date .. ' ',
                ['date-time-name'] = comp_icons.DateTime .. ' ',
                ['float-name'] = comp_icons.Float .. ' ',
                ['inline-table-name'] = comp_icons.Object .. ' ',
                ['integer-name'] = comp_icons.Value .. ' ',
                ['time-name'] = comp_icons.Time .. ' ',
            },
        },
        ['verilog'] = {
            icons = {
                ['module-name'] = comp_icons.Module .. ' ',
            },
        },
        ['yaml'] = {
            icons = {
                ['mapping-name'] = comp_icons.Object .. ' ',
                ['sequence-name'] = comp_icons.Array .. ' ',
                ['null-name'] = comp_icons.Null .. ' ',
                ['boolean-name'] = comp_icons.Boolean .. ' ',
                ['string-name'] = comp_icons.String .. ' ',
                ['number-name'] = comp_icons.Value .. ' ',
                ['float-name'] = comp_icons.Float .. ' ',
                ['integer-name'] = comp_icons.Value .. ' ',
            },
        },
        ['yang'] = {
            icons = {
                ['module-name'] = comp_icons.Module .. ' ',
                ['augment-path'] = ' ',
                ['container-name'] = ' ',
                ['grouping-name'] = ' ',
                ['typedef-name'] = ' ',
                ['identity-name'] = ' ',
                ['list-name'] = '﬘ ',
                ['leaf-list-name'] = ' ',
                ['leaf-name'] = ' ',
                ['action-name'] = ' ',
            },
        },
        ['ruby'] = {
            icons = {
                ['class-name'] = '::',
                ['method-name'] = '#',
            },
        },
    },
    separator = ' ' .. general_icons.CaretRight .. ' ',
})
