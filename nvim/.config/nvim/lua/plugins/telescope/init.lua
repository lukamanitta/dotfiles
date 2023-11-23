-- TODO: all of this. this is just basically functional

local actions = require("telescope.actions")
local previewers = require("telescope.previewers")
local Job = require("plenary.job")
local general_icons = require("icons").general

function smart_buf_preview_maker(filepath, bufnr, opts)
    opts = opts or {}
    filepath = vim.fn.expand(filepath)
    Job:new({
        command = "file",
        args = { "--mime-type", "-b", filepath },
        on_exit = function(j)
            local mime_type = vim.split(j:result()[1], "/")[1]
            if mime_type == "text" then
                previewers.buffer_previewer_maker(filepath, bufnr, opts)
            else
                -- maybe we want to write something to the buffer here
                vim.schedule(function()
                    vim.api.nvim_buf_set_lines(
                        bufnr,
                        0,
                        -1,
                        false,
                        { "BINARY" }
                    )
                end)
            end
        end,
    }):sync()
end

require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close,
            },
            n = {
                ["<esc>"] = actions.close,
                ["q"] = actions.close,
            },
        },
        buffer_previewer_maker = smart_buf_preview_maker,

        prompt_prefix = " " .. general_icons.Search .. "  ",
        selection_caret = " " .. general_icons.ArrowRight .. " ",

        layout_strategy = "flex",
        layout_config = { flex = { flip_columns = 120 } },
    },

    pickers = {
        highlights = {
            preview = false,
        },
    },

    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case", -- smart_case | ignore_case | respect_case
        },
    },
})

-- require("plugins.plugin").custom_hl
require("plugins.telescope.keybinds")
