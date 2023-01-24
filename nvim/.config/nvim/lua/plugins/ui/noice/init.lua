---@diagnostic disable: undefined-doc-name
local general_icons = require("assets.icons").general
local comp_icons = require("assets.icons").types

require("plugins.ui.noice.custom_hl")

local cmdline_popup_options = ({
    classic = {
        position = {
            row = "50%",
            col = "50%",
        },
        win_options = {
            winhighlight = {
                FloatBorder = "NoiceCmdlinePopup",
            },
        },
    },
    flat = {
        position = {
            row = "50%",
            col = "50%",
        },
        border = {
            style = "none",
            padding = { 1, 2 },
        },
        win_options = {
            winhighlight = {
                Normal = "NoiceCmdlinePopup",
            },
        },
    },
})[require("settings.globals").float_style]

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
            shell = { pattern = "^:%s*!", icon = " $ ", lang = "sh" },
            lua = { pattern = "^:%s*lua%s+", icon = "  ", lang = "lua" },
            help = { pattern = "^:%s*he?l?p?%s+", icon = "  " },
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
        enabled = true, -- enables the Noice messages UI
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
        cmdline_popup = cmdline_popup_options,
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
    },

    ---@type table<string, NoiceFilter>
    status = {}, --@see the section on statusline components below

    ---@type NoiceFormatOptions
    format = {}, -- @see section on formatting
})

local random_range = require("utils.math").random_range
local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local Set = require("utils.collections.Set")

vim.cmd("hi! link NoiceCmdlinePopupBorder FloatBorder")
vim.cmd("hi NoiceCmdlineIcon guifg=" .. get_hi_group_fg("FloatBorder"))

local views = { "Help", "Lua" }
local available_colours = Set:new({ 1, 2, 3, 4, 5, 6 })

for _, view in ipairs(views) do
    local random_num = random_range(1, available_colours:size())
    local colour = available_colours:at(random_num)
    local border_hl_name = "NoiceCmdlinePopupBorder" .. view
    local icon_hl_name = "NoiceCmdlineIcon" .. view
    vim.cmd(
        "hi "
        .. border_hl_name
        .. " guibg="
        .. get_hi_group_bg("NoiceCmdlinePopupBorder")
        .. " guifg="
        .. get_hi_group_fg("rainbowcol" .. colour)
    )
    vim.cmd(
        "hi "
        .. icon_hl_name
        .. " guifg="
        .. get_hi_group_fg("rainbowcol" .. colour)
    )
    available_colours:remove(colour)
end

vim.o.cmdheight = 0
