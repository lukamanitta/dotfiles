local get_hex = require("cokeline.utils").get_hex
local blend_rgb = require("utils.color").blend_rgb
-- local multiply_hex_brightness = require("utils.color").multiply_hex_brightness

vim.cmd("hi! TablineFill guibg=" .. get_hex("Normal", "bg"))
vim.cmd("hi! Tabline guibg=" .. get_hex("Normal", "bg"))

local general_icons = require("assets.icons").general

local buffer_diagnostic_blend = 0.2

local buffer_bg_func = function(buffer)
    local diag_status_colour = buffer.diagnostics.errors ~= 0
        and get_hex("DiagnosticError", "fg")
        or buffer.diagnostics.warnings ~= 0 and get_hex("DiagnosticWarn", "fg")
        or nil
    if buffer.is_focused then
        if diag_status_colour then
            return blend_rgb(
                get_hex("BarHighlight", "bg"),
                diag_status_colour,
                buffer_diagnostic_blend
            )
        else
            return get_hex("BarHighlight", "bg")
        end
    else
        if diag_status_colour then
            return blend_rgb(
                get_hex("BarBackground", "bg"),
                diag_status_colour,
                buffer_diagnostic_blend
            )
        else
            return get_hex("BarBackground", "bg")
        end
    end
end

local components = {
    separator = {
        text = " ",
        bg = get_hex("StableNormal", "bg"),
        truncation = { priority = 1 },
    },
    space = {
        text = " ",
        truncation = { priority = 1 },
    },
    left_half_circle = {
        text = "",
        fg = buffer_bg_func,
        bg = get_hex("StableNormal", "bg"),
        truncation = {
            priority = 1,
        },
    },
    right_half_circle = {
        text = "",
        fg = buffer_bg_func,
        bg = get_hex("StableNormal", "bg"),
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
            -- If file name is init.lua, return the file's parent directory name + file name
            local filename = vim.fn.fnamemodify(buffer.filename, ":r")
            if buffer.filename == "init.lua" then
                -- Get name of directory immediately above init.lua
                local parent_dir = vim.fn.fnamemodify(buffer.path, ":h:t")
                filename = parent_dir .. "/" .. filename
            end
            return filename
        end,
        fg = function(buffer)
            return nil
        end,
        style = function(buffer)
            return buffer.is_focused and "bold"
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
            return nil
        end,
        style = function(buffer)
            return buffer.is_focused and "bold"
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
        focus_on_delete = "prev",      -- 'prev' | 'next',
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
                fg = get_hex("StableNormal", "fg"),
                bg = get_hex("StatusLine", "bg"),
                style = "bold",
            },
        },
    },
    rendering = {
        max_buffer_width = min_buffer_width + 20,
    },
    default_hl = {
        fg = function(buffer)
            return buffer.is_focused and get_hex("StableNormal", "fg")
                or get_hex("Comment", "fg")
        end,
        bg = buffer_bg_func,
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
