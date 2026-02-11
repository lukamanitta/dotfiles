local git_head_name = ""

-- "VimEnter" not working...
vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged", "BufReadPost" }, {
    pattern = "*",
    callback = function()
        if
            vim.bo.filetype == "TelescopePrompt"
            or vim.bo.filetype == "neo-tree"
        then
            return
        end
        local head = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
        if not head or head == "" or head:find("fatal") then
            git_head_name = ""
        else
            git_head_name =
                string.format(require("ui.icons").git.Branch .. " %s", head)
        end
    end,
})

return function()
    return git_head_name
end
