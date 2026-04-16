vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

vim.pack.add({
    {
        src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
        version = "v3.x",
    },
})

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
