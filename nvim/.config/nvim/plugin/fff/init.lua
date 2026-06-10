vim.pack.add({
    {
        src = "https://github.com/dmtrKovalenko/fff.nvim",
    },
})

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        if ev.data.spec.name == "fff.nvim" then
            if not ev.data.active then
                vim.cmd.packadd("fff.nvim")
            end
            require("fff.download").download_or_build_binary()
            vim.notify(
                "fff built successfully",
                vim.log.levels.INFO,
                { title = "Pack" }
            )
        end
    end,
})

require("fff").setup({
    base_path = vim.fn.getcwd(),
    prompt = " " .. require("ui.icons").general.Search .. "  ",
    lazy_sync = true,
    layout = {
        height = 0.8,
        width = 0.8,
        prompt_position = "top",
        preview_position = "right",
        preview_size = 0.5,
        flex = { size = 130, wrap = "top" },
    },
    hl = {
        -- winhl = {
        --     prompt = "Normal:StatusLineNC,FloatBorder:StatusLineNC,FloatTitle:StatusLineNC",
        --     list = "Normal:StatusLine,FloatBorder:StatusLine,FloatTitle:StatusLine",
        --     preview = "Normal:StatusLine,FloatBorder:StatusLine,FloatTitle:StatusLine",
        -- },
        -- normal = "StatusLine",
        -- border = "StatusLine",
        -- title = "StatusLine",

        cursor = "CursorLine",

        git_staged = "Added",
        git_deleted = "Removed",
        git_ignored = "Ignored",
        git_renamed = "Changed",
        git_modified = "Changed",
        git_untracked = "Untracked",

        git_sign_staged = "Added",
        git_sign_deleted = "Removed",
        git_sign_ignored = "Ignored",
        git_sign_renamed = "Changed",
        git_sign_modified = "Changed",
        git_sign_untracked = "Untracked",

        git_sign_staged_selected = "Added",
        git_sign_deleted_selected = "Removed",
        git_sign_ignored_selected = "Ignored",
        git_sign_renamed_selected = "Changed",
        git_sign_modified_selected = "Changed",
        git_sign_untracked_selected = "Untracked",
    },
})
