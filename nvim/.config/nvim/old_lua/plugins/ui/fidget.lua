local general_icons = require("assets.icons").general

require("fidget").setup({
    text = {
        spinner = "dots_snake", -- animation shown when tasks are ongoing
        done = general_icons.CheckThick, -- character shown when all tasks are complete
        commenced = "Started", -- message shown when task starts
        completed = "Completed", -- message shown when task completes
    },

    align = {
        bottom = true, -- align fidgets along bottom edge of buffer
        right = true, -- align fidgets along right edge of buffer
    },

    timer = {
        spinner_rate = 125, -- frame rate of spinner animation, in ms
        fidget_decay = 2000, -- how long to keep around empty fidget, in ms
        task_decay = 1000, -- how long to keep around completed task, in ms
    },

    window = {
        relative = "win", -- where to anchor, either "win" or "editor"
        blend = 0, -- &winblend for the window
        zindex = nil, -- the zindex value for the window
    },

    fmt = {
        leftpad = true, -- right-justify text in fidget box
        stack_upwards = true, -- list of tasks grows upwards
        max_width = 0, -- maximum width of the fidget box
        fidget = function(fidget_name, spinner) -- function to format fidget title
            return string.format("%s %s", spinner, fidget_name)
        end,
        task = function(task_name, message, percentage) -- function to format each task line
            return string.format(
                "%s%s [%s]",
                message,
                percentage and string.format(" (%s%%)", percentage) or "",
                task_name
            )
        end,
    },

    -- sources = {                 -- Sources to configure
    --   * = {                     -- Name of source
    --     ignore = false,         -- Ignore notifications from this source
    --   },
    -- },
    --
    debug = {
        logging = false, -- whether to enable logging, for debugging
        strict = false, -- whether to interpret LSP strictly
    },
})

-- Stops fidget when exiting vim (removes "line number out of range") after
-- exiting.
vim.api.nvim_create_autocmd("VimLeavePre", { command = "silent! FidgetClose" })