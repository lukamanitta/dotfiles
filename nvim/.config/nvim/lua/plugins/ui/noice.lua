---@diagnostic disable: undefined-doc-name
local general_icons = require("assets.icons").general
local cmdline_hl_group = "Conditional"

require("noice").setup({
    cmdline = {
        enabled = true, -- disable if you use native command line UI
        view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
        opts = { buf_options = { filetype = "vim" } }, -- enable syntax highlighting in the cmdline
        icons = {
            ["/"] = {
                icon = " " .. general_icons.Search .. " ",
                hl_group = "DiagnosticWarn",
            },
            ["?"] = {
                icon = " " .. general_icons.Search .. " ",
                hl_group = "DiagnosticWarn",
            },
            [":"] = {
                icon = " " .. general_icons.Shell .. " ",
                hl_group = cmdline_hl_group,
                firstc = false,
            },
        },
    },
    messages = {
        -- NOTE: If you enable noice messages UI, noice cmdline UI is enabled
        -- automatically. You cannot enable noice messages UI only.
        -- It is current neovim implementation limitation.  It may be fixed later.
        enabled = false, -- disable if you use native messages UI
    },
    popupmenu = { -- cmdline completion
        enabled = true, -- disable if you use something like cmp-cmdline
        ---@type 'nui'|'cmp'
        backend = "nui", -- backend to use to show regular cmdline completions
        -- You can specify options for nui under `config.views.popupmenu`
    },
    history = {
        -- options for the message history that you get with `:Noice`
        view = "split",
        opts = { enter = true },
        filter = {
            event = "msg_show",
            ["not"] = { kind = { "search_count", "echo" } },
        },
    },
    notify = {
        enabled = false,
    },
    hacks = {
        skip_duplicate_messages = false,
    },
    throttle = 1000 / 30,

    ---@type table<string, NoiceViewOptions>
    views = {
        cmdline_popup = {
            position = {
                row = 12,
                col = "50%",
            },
            win_options = {
                winhighlight = {
                    FloatBorder = cmdline_hl_group,
                },
            },
        },
    },

    ---@type NoiceRouteConfig[]
    routes = {
        {
            filter = {
                event = "cmdline",
                find = "^%s*[/?]",
            },
            view = "cmdline",
        },
        {
            filter = { event = "msg_showmode" },
            view = "notify",
        },
    },

    ---@type table<string, NoiceFilter>
    status = {}, --@see the section on statusline components below

    ---@type NoiceFormatOptions
    format = {}, -- @see section on formatting
})

vim.o.cmdheight = 0
