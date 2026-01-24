local actions = require("telescope.actions")

local border_chars_none = { " ", " ", " ", " ", " ", " ", " ", " " }

require("telescope").setup({
    defaults = {
        mappings = {
            i = { ["<esc>"] = actions.close },
            n = {
                ["<esc>"] = actions.close,
                ["q"] = actions.close,
            },
        },

        borderchars = {
            prompt = border_chars_none,
            results = border_chars_none,
            preview = border_chars_none,
        },

        prompt_prefix = " " .. require("ui.icons").general.Search .. "  ",
        selection_caret = " " .. require("ui.icons").general.ArrowRight .. "  ",

        sort_mru = true,
        sorting_strategy = "ascending",
        results_title = false,
        prompt_title = false,
        hl_result_eol = false,
        border = true,
        winblend = 0,

        layout_strategy = "flex",
        layout_config = {
            prompt_position = "top",
            flex = { flip_columns = 120 },
        },
        path_display = {
            filename_first = {
                reverse_directories = false,
            },
        },

        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
        },
    },
})
require("telescope").load_extension("fzf")
require("plugins.telescope.keybinds")
