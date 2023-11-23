local filesystem_icons = require("icons").filesystem
local git_icons = require("icons").git
local general_icons = require("icons").general

local neotree = require("neo-tree")

vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

neotree.setup({
    close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    sort_case_insensitive = false,
    sort_function = nil,
    default_component_configs = {
        container = {
            enable_character_fade = true,
        },
        indent = {
            indent_size = 2,
            padding = 1, -- extra padding on left hand side
            -- indent guides
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            -- expander config, needed for nesting files
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
        },
        icon = {
            folder_closed = filesystem_icons.Folder,
            folder_open = filesystem_icons.FolderOpen,
            folder_empty = filesystem_icons.FolderEmpty,
            default = filesystem_icons.File,
            highlight = "NeoTreeFileIcon",
        },
        name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
        },
        modified = {
            symbol = general_icons.CircleSmall,
            highlight = "NeoTreeModified",
        },
        git_status = {
            symbols = {
                -- Change type
                added = git_icons.Added,
                deleted = git_icons.Removed,
                modified = git_icons.Modified,
                renamed = git_icons.Renamed,
                -- Status type
                untracked = git_icons.Untracked,
                ignored = git_icons.Ignored,
                unstaged = git_icons.Unstaged,
                staged = git_icons.Staged,
                conflict = git_icons.Merge,
            },
        },
        file_size = {
            enabled = false,
            required_width = 64, -- min width of window required to show this column
        },
        type = {
            enabled = false,
            required_width = 122, -- min width of window required to show this column
        },
        last_modified = {
            enabled = false,
            required_width = 88, -- min width of window required to show this column
        },
        created = {
            enabled = false,
            required_width = 110, -- min width of window required to show this column
        },
        symlink_target = {
            enabled = false,
        },
    },
    window = {
        position = "left",
        width = 30,
        mapping_options = {
            noremap = true,
            nowait = true,
        },
        mappings = {
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["<c-s>"] = "open_split",
            ["<c-v>"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",
            ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            ["a"] = "add",
            ["A"] = "add_directory",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy", -- takes text input for destination
            ["m"] = "move", -- takes text input for destination
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
        },
    },
    event_handlers = {
        {
            event = "file_opened",
            handler = function(_)
                neotree.close_all()
            end,
        },
        {
            event = "neo_tree_buffer_enter",
            handler = function(_)
                vim.cmd("setlocal relativenumber")
            end,
        },
    },
    nesting_rules = {},
    filesystem = {
        filtered_items = {
            visible = true, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_by_name = {
                ".DS_Store",
                "thumbs.db",
                --"node_modules"
            },
            never_show = { -- remains hidden even if visible is toggled to true
                ".DS_Store",
                --"thumbs.db"
            },
        },
        follow_current_file = {
            enabled = true,
        },
        group_empty_dirs = false,
        hijack_netrw_behavior = "open_default",
        -- "open_current",  -- netrw disabled, opening a directory opens within the
        -- window like netrw would, regardless of window.position
        -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
        use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
        -- instead of relying on nvim autocmd events.

        window = {
            mappings = {
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
                ["H"] = "toggle_hidden",
                ["/"] = "fuzzy_finder",
                ["D"] = "fuzzy_finder_directory",
                ["f"] = "filter_on_submit",
                ["<c-x>"] = "clear_filter",
                ["[g"] = "prev_git_modified",
                ["]g"] = "next_git_modified",
            },
        },
    },
    buffers = {
        follow_current_file = {
            enabled = true,
        },
        show_unloaded = true,
        group_empty_dirs = true,
        window = {
            mappings = {
                ["bd"] = "buffer_delete",
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
            },
        },
    },
    git_status = {
        window = {
            position = "float",
            mappings = {
                ["A"] = "git_add_all",
                ["gu"] = "git_unstage_file",
                ["ga"] = "git_add_file",
                ["gr"] = "git_revert_file",
                ["gc"] = "git_commit",
                ["gp"] = "git_push",
                ["gg"] = "git_commit_and_push",
            },
        },
    },
})

-- require("plugins.neo-tree.custom_hl")
require("plugins.neo-tree.keybinds")
