local git_head_name = ""

vim.api.nvim_create_autocmd({ "DirChanged", "BufEnter", "BufWinEnter" }, {
    callback = function()
        local head = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
        if not head or head == "" or head:find("fatal") then
            git_head_name = ""
        else
            git_head_name = head
        end
    end,
})


return function()
    return string.format(require("ui.icons").git.Branch .. " %s", git_head_name)
end
