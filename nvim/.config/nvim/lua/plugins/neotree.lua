local cmd = vim.cmd

local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg

local filesystem_icons = require("assets.icons").filesystem
local git_icons = require("assets.icons").git
local general_icons = require("assets.icons").general

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
                renamed = git_icons.Modified,
                -- Status type
                untracked = git_icons.Untracked,
                ignored = git_icons.Ignored,
                unstaged = git_icons.Unstaged,
                staged = git_icons.Staged,
                conflict = git_icons.Merge,
            },
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
        follow_current_file = true, -- This will find and focus the file in the active buffer every
        -- time the current file is changed while the tree is open.
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
        follow_current_file = true,
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

cmd("hi NeoTreeNormal guibg=" .. get_hi_group_bg("Normal"))
cmd("hi link NeoTreeNormalNC NeoTreeNormal")
cmd(
    "hi NeoTreeFloatBorder guibg="
    .. get_hi_group_bg("NeoTreeNormal")
    .. " guifg="
    .. get_hi_group_fg("NeoTreeFloatBorder")
)
cmd("hi NeoTreeFloatTitle guibg=" .. get_hi_group_bg("NeoTreeNormal"))
cmd(
    "hi VertSplit guibg="
    .. get_hi_group_bg("Normal")
    .. " guifg="
    .. get_hi_group_bg("Normal")
)

-- For colourschemes that support NvimTree but not NeoTree
-- vim.cmd([[
-- highlight! link NeoTreeDirectoryIcon NvimTreeFolderIcon
-- highlight! link NeoTreeDirectoryName NvimTreeFolderName
-- highlight! link NeoTreeSymbolicLinkTarget NvimTreeSymlink
-- highlight! link NeoTreeRootName NvimTreeRootFolder
-- highlight! link NeoTreeDirectoryName NvimTreeOpenedFolderName
-- highlight! link NeoTreeFileNameOpened NvimTreeOpenedFile
-- ]])
