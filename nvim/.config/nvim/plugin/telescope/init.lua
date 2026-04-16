vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
})

vim.pack.add({
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
})

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

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        if ev.data.spec.name == "telescope-fzf-native.nvim" then
            vim.system({ "make", "-C", ev.data.path }):wait()
            vim.notify(
                "telescope-fzf-native built successfully",
                vim.log.levels.INFO,
                { title = "Pack" }
            )
        end
    end,
})

vim.pack.add({
    {
        src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
    },
})

require("telescope").load_extension("fzf")
