local actions = require("telescope.actions")

require("telescope").setup({
    defaults = {
        mappings = {
            i = { ["<esc>"] = actions.close },
            n = {
                ["<esc>"] = actions.close,
                ["q"] = actions.close,
            }
        }
    }
})
require("telescope").load_extension("fzf")
require("plugins.telescope.keybinds")
