local icons = require('assets.icons').comp_types

require('nvim-gps').setup({
    icons = {
        ['class-name'] = icons.Class, -- Classes and class-like objects
        ['function-name'] = icons.Function, -- Functions
        ['method-name'] = icons.Method, -- Methods (functions inside class-like objects)
        ['container-name'] = icons.Struct, -- Containers (example: lua tables)
        ['tag-name'] = icons.Tag, -- Tags (example: html tags)
    },
    -- Add custom configuration per language or
    -- Disable the plugin for a language
    -- Any language not disabled here is enabled by default
    -- languages = {
    -- ["bash"] = false, -- disables nvim-gps for bash
    -- ["go"] = false,   -- disables nvim-gps for golang
    -- ["ruby"] = {
    --      separator = '|', -- Overrides default separator with '|'
    --	icons = {
    --	        -- Default icons not specified in the lang config
    --		-- will fallback to the default value
    --		-- "container-name" will fallback to default because it's not set
    --		["function-name"] = '',    -- to ensure empty values, set an empty string
    --		["tag-name"] = ''
    --		["class-name] = '::'",
    --		["method-name"] = '#',
    --	}
    --}
    -- },
    separator = ' > ',
})
