local icons = require("ui.icons")

require("neo-tree").setup({
    default_component_configs = {
        icon = {
            folder_closed = icons.filesystem.Folder,
            folder_open = icons.filesystem.FolderOpen,
            folder_empty = icons.filesystem.FolderEmpty,
            default = icons.filesystem.File,
            highlight = "NeoTreeFileIcon",
        },
        modified = {
            symbol = icons.general.CircleSmall,
            highlight = "NeoTreeModified",
        },
        git_status = {
            symbols = {
                -- Change type
                added = icons.git.Added,
                deleted = icons.git.Removed,
                modified = icons.git.Modified,
                renamed = icons.git.Renamed,
                -- Status type
                untracked = icons.git.Untracked,
                ignored = icons.git.Ignored,
                unstaged = icons.git.Unstaged,
                staged = icons.git.Staged,
                conflict = icons.git.Merge,
            },
        },
    },
    filesystem = {
        filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
                "node_modules",
            },
            never_show = {
                ".DS_Store",
                "thumbs.db",
            },
        },
        follow_current_file = {
            enabled = true,
        },
    },
})

local background = require("h").get_hl("StatusLine", "bg#")

vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = background })
vim.api.nvim_set_hl(
    0,
    "NeoTreeFloatBorder",
    { bg = background, fg = background }
)
vim.api.nvim_set_hl(0, "NeoTreeFloatTitle", { bg = background })
vim.api.nvim_set_hl(0, "NeoTreeTitleBar", { bg = background, fg = background })

require("plugins.neo-tree.keybinds")
