local get_hex = require("cokeline.utils").get_hex
local change_hex_brightness = require("utils.color").change_hex_brightness

vim.cmd("hi! link TabLineFill Normal")

local general_icons = require("assets.icons").general

local background = get_hex("Normal")
local errors_fg = get_hex("DiagnosticError", "fg")
local warnings_fg = get_hex("DiagnosticWarn", "fg")

local focused_tab_brightness_diff = 1.2

local components = {
    separator = {
        text = " ",
        bg = get_hex("Normal", "bg"),
        truncation = { priority = 1 },
    },

    space = {
        text = " ",
        truncation = { priority = 1 },
    },

    left_half_circle = {
        text = "",
        fg = function(buffer)
            if buffer.is_focused then
                return change_hex_brightness(
                    get_hex("ColorColumn", "bg"),
                    focused_tab_brightness_diff
                )
            else
                return get_hex("ColorColumn", "bg")
            end
        end,
        bg = get_hex("Normal", "bg"),
        truncation = {
            priority = 1,
        },
    },

    right_half_circle = {
        text = "",
        fg = function(buffer)
            if buffer.is_focused then
                return change_hex_brightness(
                    get_hex("ColorColumn", "bg"),
                    focused_tab_brightness_diff
                )
            else
                return get_hex("ColorColumn", "bg")
            end
        end,
        bg = get_hex("Normal", "bg"),
        truncation = {
            priority = 1,
        },
    },

    devicon = {
        text = function(buffer)
            return buffer.devicon.icon
        end,
        fg = function(buffer)
            return buffer.devicon.color
        end,
        truncation = { priority = 1 },
    },

    filename_root = {
        text = function(buffer)
            return vim.fn.fnamemodify(buffer.filename, ":r")
        end,
        fg = function(buffer)
            return (buffer.diagnostics.errors ~= 0 and errors_fg)
                or (buffer.diagnostics.warnings ~= 0 and warnings_fg)
                or nil
        end,
        style = function(buffer)
            return (
                (buffer.is_focused and buffer.diagnostics.errors ~= 0)
                    and "bold,underline"
                )
                or (buffer.is_focused and "bold")
                or (buffer.diagnostics.errors ~= 0 and "underline")
                or nil
        end,
        truncation = {
            priority = 3,
            direction = "middle",
        },
    },

    filename_extension = {
        text = function(buffer)
            local ext = vim.fn.fnamemodify(buffer.filename, ":e")
            return ext ~= "" and "." .. ext or ""
        end,
        fg = function(buffer)
            return (buffer.diagnostics.errors ~= 0 and errors_fg)
                or (buffer.diagnostics.warnings ~= 0 and warnings_fg)
                or nil
        end,
        style = function(buffer)
            return (
                (buffer.is_focused and buffer.diagnostics.errors ~= 0)
                    and "bold,underline"
                )
                or (buffer.is_focused and "bold")
                or (buffer.diagnostics.errors ~= 0 and "underline")
                or nil
        end,
        truncation = {
            priority = 2,
            direction = "left",
        },
    },

    unsaved = {
        text = function(buffer)
            return buffer.is_modified and general_icons.CircleSmall or ""
        end,
        fg = "#98bb6c",
        truncation = { priority = 1 },
    },
}

local min_buffer_width = 20
local get_remaining_space = function(buffer)
    local used_space = 0
    for _, component in pairs(components) do
        used_space = used_space
            + vim.fn.strwidth(
                (type(component.text) == "string" and component.text)
                or (
                type(component.text) == "function"
                    and component.text(buffer)
                )
            )
    end
    return math.max(0, min_buffer_width - used_space)
end

local left_padding = {
    text = function(buffer)
        local remaining_space = get_remaining_space(buffer)
        return string.rep(" ", remaining_space / 2 + remaining_space % 2)
    end,
}

local right_padding = {
    text = function(buffer)
        local remaining_space = get_remaining_space(buffer)
        return string.rep(" ", remaining_space / 2)
    end,
}

require("cokeline").setup({
    show_if_buffers_are_at_least = 1,
    buffers = {
        focus_on_delete = "prev", -- 'prev' | 'next',
        new_buffers_position = "last", -- 'last' | 'next',
    },

    mappings = {
        cycle_prev_next = true, --  true | false,
    },

    sidebar = {
        filetype = "neo-tree",
        components = {
            {
                text = "",
                fg = get_hex("Normal", "fg"),
                bg = get_hex("StatusLine", "bg"),
                style = "bold",
            },
        },
    },

    rendering = {
        max_buffer_width = 30,
    },

    default_hl = {
        fg = function(buffer)
            return buffer.is_focused and get_hex("Normal", "fg")
                or get_hex("Comment", "fg")
        end,
        bg = function(buffer)
            if buffer.is_focused then
                return change_hex_brightness(
                    get_hex("ColorColumn", "bg"),
                    focused_tab_brightness_diff
                )
            else
                return get_hex("ColorColumn", "bg")
            end
        end,
    },

    -- A list of components to be rendered for each buffer
    components = {
        components.separator,
        components.left_half_circle,
        left_padding,
        components.devicon,
        components.filename_root,
        components.filename_extension,
        components.space,
        right_padding,
        components.unsaved,
        components.right_half_circle,
    },
})
