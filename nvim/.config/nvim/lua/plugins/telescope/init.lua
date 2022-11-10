local actions = require("telescope.actions")
local smart_buf_preview_maker =
require("plugins.telescope.tele_utils").smart_buf_preview_maker
local general_icons = require("assets.icons").general

require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close,
            },
            n = {
                ["<esc>"] = actions.close,
            },
        },
        buffer_previewer_maker = smart_buf_preview_maker,

        prompt_prefix = general_icons.CaretRight .. " ",
        selection_caret = general_icons.CaretRight .. " ",
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

require("telescope").load_extension("fzf")

require("plugins.telescope.custom_hl")
