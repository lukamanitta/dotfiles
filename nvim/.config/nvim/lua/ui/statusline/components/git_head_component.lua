return function()
    local head = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
    if not head or head == "" then
        return ""
    end

    return string.format(require("ui.icons").git.Branch .. " %s", head)
end
