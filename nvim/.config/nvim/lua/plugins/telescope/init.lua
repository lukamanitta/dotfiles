local actions = require("telescope.actions")
local smart_buf_preview_maker =
require("plugins.telescope.tele_utils").smart_buf_preview_maker
local general_icons = require("assets.icons").general
local table_merge = require("utils.tables").table_merge

require("plugins.telescope.custom_hl")

require("telescope").setup({
    defaults = table_merge({
        mappings = {
            i = {
                ["<esc>"] = actions.close,
            },
            n = {
                ["<esc>"] = actions.close,
            },
        },
        buffer_previewer_maker = smart_buf_preview_maker,

        prompt_prefix = " " .. general_icons.Search .. "  ",
        selection_caret = general_icons.ArrowRight .. " ",

        layout_strategy = "flex",
        layout_config = { flex = { flip_columns = 120 } },
    }, require("plugins.telescope.theme")),

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

require("telescope").load_extension("fzf")
