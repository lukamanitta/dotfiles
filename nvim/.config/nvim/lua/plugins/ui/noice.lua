---@diagnostic disable: undefined-doc-name
local general_icons = require("assets.icons").general
local comp_icons = require("assets.icons").types
local cmdline_hl_group = "Conditional"

require("noice").setup({
    cmdline = {
        enabled = true, -- disable if you use native command line UI
        view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
        opts = { lang = "vim" }, -- enable syntax highlighting in the cmdline
        format = {
            cmdline = {
                pattern = "^:",
                icon = " " .. general_icons.Shell .. " ",
                lang = "vim",
            },
            search_down = {
                kind = "search",
                pattern = "^/",
                icon = " " .. general_icons.Search .. " ",
                lang = "regex",
                view = "cmdline",
            },
            search_up = {
                kind = "search",
                pattern = "^%?",
                icon = " " .. general_icons.Search .. " ",
                lang = "regex",
                view = "cmdline",
            },
            filter = { pattern = "^:%s*!", icon = " $ ", lang = "sh" },
            lua = { pattern = "^:%s*lua%s+", icon = "  ", lang = "lua" },
            substitute = {
                pattern = "^:s;",
                icon = " " .. general_icons.Replace .. " ",
                lang = "regex",
                view = "cmdline",
            },
            global_substitute = {
                pattern = "^:%%s;",
                icon = " " .. general_icons.Replace .. " ",
                lang = "regex",
                view = "cmdline",
            },
        },
    },
    messages = {
        -- NOTE: If you enable messages, then the cmdline is enabled automatically.
        -- This is a current Neovim limitation.
        enabled = false, -- enables the Noice messages UI
        view = "notify", -- default view for messages
        view_error = "notify", -- view for errors
        view_warn = "notify", -- view for warnings
        view_history = "split", -- view for :messages
        view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
    },
    popupmenu = { -- cmdline completion
        enabled = true, -- disable if you use something like cmp-cmdline
        ---@type 'nui'|'cmp'
        backend = "nui", -- backend to use to show regular cmdline completions
        -- You can specify options for nui under `config.views.popupmenu`
        kind_icons = comp_icons, -- set to `false` to disable icons
    },
    history = {
        -- options for the message history that you get with `:Noice`
        view = "split",
        opts = { enter = true, format = "details" },
        filter = {
            event = { "msg_show", "notify" },
            ["not"] = { kind = { "search_count", "echo" } },
        },
    },
    notify = {
        enabled = false,
        view = "notify",
    },
    lsp = {
        progress = { enabled = false },
        override = {},
        hover = {},
        signature = { enabled = false },
    },
    message = { enabled = false },
    documentation = { enabled = false },
    markdown = { hover = {}, highlights = {} },
    health = { checker = true },
    smart_move = {
        enabled = true,
        excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
    },
    throttle = 1000 / 30,

    ---@type table<string, NoiceViewOptions>
    views = {
        cmdline_popup = {
            position = {
                row = "50%",
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
