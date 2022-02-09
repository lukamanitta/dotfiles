local apply_globals = require('utils.config').apply_globals

local filesystem_icons = require('assets.icons').filesystem
local lsp_icons = require('assets.icons').lsp
local git_icons = require('assets.icons').git
local general_icons = require('assets.icons').general

apply_globals({
    nvim_tree_indent_markers = 0,
    nvim_tree_git_hl = 1,
    nvim_tree_highlight_opened_files = 1,
    nvim_tree_root_folder_modifier = ':~',
    nvim_tree_add_trailing = 1, -- Adds trailing slash to folder names
    nvim_tree_group_empty = 1,
    nvim_tree_disable_window_picker = 0,
    nvim_tree_icon_padding = ' ',
    nvim_tree_symlink_arrow = ' >> ',
    nvim_tree_respect_buf_cwd = 0,
    nvim_tree_create_in_closed_folder = 1,
    nvim_tree_window_picker_exclude = {
        buftype = {
            'terminal',
        },
        filetype = {
            'notify',
            'packer',
            'Trouble',
        },
    },
    nvim_tree_show_icons = {
        git = 1,
        folders = 1,
        files = 1,
        folder_arrows = 1,
    },
    nvim_tree_icons = {
        default = filesystem_icons.File,
        symlink = filesystem_icons.FileSymlink,
        git = {
            unstaged = git_icons.Unstaged,
            staged = git_icons.Staged,
            unmerged = git_icons.Merge,
            renamed = git_icons.Modified,
            untracked = git_icons.Untracked,
            deleted = git_icons.Removed,
            ignored = git_icons.Ignored,
        },
        folder = {
            default = filesystem_icons.Folder,
            open = filesystem_icons.FolderOpen,
            empty = filesystem_icons.FolderEmpty,
            empty_open = filesystem_icons.FolderEmptyOpen,
            symlink = filesystem_icons.FolderSymlink,
            symlink_open = filesystem_icons.FolderOpen,
        },
    },
})

require('nvim-tree').setup({
    nvim_tree_ignore = { '.git', 'node_modules', '.cache' },
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = {},
    auto_close = true, -- Close nvim when tree is last window
    open_on_tab = false, -- Open when changing tab
    hijack_cursor = true, -- Put cursor to start of filename
    update_cwd = true, -- Update root dir of tree on DirChanged event
    update_to_buf_dir = { --Hijack new directory buffers when opened
        enable = true,
        auto_open = false,
    },
    diagnostics = {
        enable = true,
        icons = {
            error = lsp_icons.Error,
            warning = lsp_icons.Warn,
            hint = lsp_icons.Hint,
            info = lsp_icons.Info,
        },
    },
    update_focused_file = { -- Move cursor to focused file
        enable = true,
        update_cwd = true,
        ignore_list = {},
    },
    system_open = { -- Options for the system open command (s)
        cmd = nil,
        args = {},
    },
    filters = {
        dotfiles = false,
        custom = {},
    },
    git = {
        enable = true,
        ignore = false,
        timeout = 500,
    },
    view = {
        width = 30,
        height = 30,
        hide_root_folder = false,
        side = 'left',
        auto_resize = false,
        mappings = {
            custom_only = false,
            list = {},
        },
        number = true,
        relativenumber = true,
        signcolumn = 'yes',
    },
    trash = {
        cmd = 'trash',
        require_confirm = true,
    },
    actions = {
        change_dir = {
            global = false,
        },
        open_file = {
            quit_on_open = true,
        },
    },
})
