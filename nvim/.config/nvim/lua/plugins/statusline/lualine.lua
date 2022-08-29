-- Modified Eviline config for lualine
-- Credit: shadmansaleh
local lualine = require("lualine")

local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg

local git_icons = require("assets.icons").git
local lsp_icons = require("assets.icons").lsp
local general_icons = require("assets.icons").general

local colorscheme = require("settings.globals").colourscheme
local theme, _ = colorscheme:match("(.+)_(.+)") -- Remove colourscheme modifier

-- Color table for highlights
local colors = {
    bg = get_hi_group_bg("StatusLine"),
    fg = get_hi_group_fg("lualine_c_normal"),
    yellow = "#ECBE7B",
    cyan = "#008080",
    darkblue = "#081633",
    green = "#98be65",
    orange = "#FF8800",
    violet = "#a9a1e1",
    magenta = "#c678dd",
    blue = "#51afef",
    red = "#ec5f67",
    filename = get_hi_group_fg("Keyword"),
    endblock_fg = get_hi_group_bg("StatusLine"),
    endblock_bg = get_hi_group_bg("Normal"),
}

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

-- Config
local config = {
    options = {
        -- Disable sections and component separators
        component_separators = "",
        section_separators = "",
        -- disabled_filetypes = { 'Trouble', 'NvimTree' },
        disabled_filetypes = { "Trouble", "NvimTree" },
        -- theme = theme,
        theme = {
            -- We are going to use lualine_c an lualine_x as left and
            -- right section. Both are highlighted by c theme .  So we
            -- are just setting default looks o statusline
            normal = { c = { fg = colors.fg, bg = colors.bg } },
            inactive = { c = { fg = colors.fg, bg = colors.bg } },
        },
        globalstatus = vim.o.laststatus == 3,
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
    extensions = { "nvim-tree" },
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
--         return ""
--     end,
--     color = { fg = colors.endblock_fg, bg = colors.endblock_bg }, -- Sets highlighting of component
--     left_padding = 0, -- We don't need space before this
--     right_padding = 0,
-- })

local get_buf_icon = require("utils.config").get_buf_icon
ins_left({
    -- mode component
    function()
        -- auto change color according to neovims mode
        local mode_color = {
            n = colors.blue,
            i = colors.green,
            v = colors.red,
            [""] = colors.blue,
            V = colors.blue,
            c = colors.magenta,
            no = colors.red,
            s = colors.orange,
            S = colors.orange,
            [""] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.red,
            ce = colors.red,
            r = colors.cyan,
            rm = colors.cyan,
            ["r?"] = colors.cyan,
            ["!"] = colors.red,
            t = colors.red,
        }
        vim.api.nvim_command(
            "hi! LualineMode guifg="
                .. mode_color[vim.fn.mode()]
                .. " guibg="
                .. get_hi_group_bg("lualine_c_normal")
        )
        if vim.api.nvim_buf_get_option(0, "filetype") == "" then
            return general_icons.Heart
        end
        return get_buf_icon(0)
    end,
    color = "LualineMode",
    left_padding = 0,
})

ins_left({
    "filename",
    condition = conditions.buffer_not_empty,
    color = { fg = colors.filename, gui = "bold" },
})

ins_left({
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = {
        error = lsp_icons.Error .. " ",
        warn = lsp_icons.Warn .. " ",
        info = lsp_icons.Info .. " ",
        hint = lsp_icons.Hint .. " ",
    },
    color_error = colors.red,
    color_warn = colors.yellow,
    color_info = colors.cyan,
})

local gps = require("nvim-gps")
ins_left({
    gps.get_location,
    condition = gps.is_available,
})

-- local treesitter = require('nvim-treesitter')
-- ins_left({
--     function()
--         return treesitter.statusline({
--             indicator_size = 40,
--             type_patterns = { 'class', 'function', 'method', 'table_constructor' },
--             transform_fn = function(line)
--                 return line:gsub('%s*[%[%(%{]*%s*$', '')
--             end,
--             separator = ' ' .. general_icons.PlayArrowRight .. ' ',
--         })
--     end,
-- })

-- Insert mid section
ins_left({
    function()
        return "%="
    end,
})

ins_left({
    -- Lsp server name .
    function()
        local Set = require("classes.Set")
        local has_value = require("utils.helpers").has_value

        local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
        local clients = vim.lsp.get_active_clients()

        if next(clients) == nil then
            return "No Active LSP"
        end

        local client_names = Set:new()
        for _, client in ipairs(clients) do
            if has_value(client.config.filetypes, buf_ft) then
                client_names:add(client.name)
            end
        end
        return client_names:to_string()
    end,
    icon = " LSP:",
    color = { fg = get_hi_group_fg("Comment"), gui = "bold" },
})

-- Add components to right sections
ins_right({
    "branch",
    icon = git_icons.Branch,
    condition = conditions.check_git_workspace,
    color = { fg = colors.violet, gui = "bold" },
})

ins_right({
    "diff",
    symbols = {
        added = git_icons.Added .. " ",
        modified = git_icons.Modified,
        removed = git_icons.Removed .. " ",
    },
    color_added = colors.green,
    color_modified = colors.orange,
    color_removed = colors.red,
    condition = conditions.hide_in_width,
})

-- ins_right({ 'location' })

ins_right({ "progress", color = { fg = colors.fg, gui = "bold" } })

-- ins_right({
--     function()
--         return ""
--     end,
--     color = { fg = colors.endblock_fg, bg = colors.endblock_bg }, -- Sets highlighting of component
--     left_padding = 0, -- We don't need space before this
-- })

lualine.setup(config)
