local apply_globals = require('utils.config').apply_globals

apply_globals({
    nvim_tree_ignore = { '.git', 'node_modules', '.cache' },
    nvim_tree_git_hl = 1,
    nvim_tree_highlight_opened_files = 1,
    nvim_tree_add_trailing = 1, -- Adds trailing slash to folder names
    nvim_tree_disable_window_picker = 0,

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
        default = '',
        symlink = '',
        git = {
            unstaged = '',
            staged = '✓',
            unmerged = '',
            renamed = '',
            untracked = '',
            deleted = '',
            ignored = '',
        },
        folder = {
            default = '',
            open = '',
            empty = '',
            empty_open = '',
            symlink = '',
            symlink_open = '',
        },
        --lsp = {
        --hint = "",
        --info = "",
        --warning = "",
        --error = ""
        --}
    },
})

require('nvim-tree').setup({
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = {},
    auto_close = true, -- Close nvim when tree is last window
    open_on_tab = false, -- Open when changing tab
    update_to_buf_dir = { --Hijack new directory buffers when opened
        enable = true,
        auto_open = false,
    },
    hijack_cursor = true, -- Put cursor to start of filename
    update_cwd = true, -- Update root dir of tree on DirChanged event
    --lsp_diagnostics = false, -- Lsp diagnostics in sign column (broken)
    update_focused_file = { -- Move cursor to focused file
        enable = true,
        update_cwd = true,
    },
    system_open = { -- Options for the system open command (s)
        cmd = nil,
        args = {},
    },

    view = {
        width = 30,
        side = 'left',
        auto_resize = false,
    },
})
