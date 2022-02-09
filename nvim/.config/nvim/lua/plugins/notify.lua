local notify = require('notify')

local lsp_icons = require('assets.icons').lsp
local general_icons = require('assets.icons').general

vim.notify = require('notify')

notify.setup({
    -- Animation style (see below for details)
    stages = 'fade_in_slide_out',

    -- Default timeout for notifications
    timeout = 5000,

    -- For stages that change opacity this is treated as the highlight behind the window
    background_colour = 'Normal',

    -- Icons for the different levels
    icons = {
        ERROR = lsp_icons.Error,
        WARN = lsp_icons.Warn,
        INFO = lsp_icons.Info,
        DEBUG = general_icons.Bug,
        TRACE = general_icons.Trace,
    },
})
