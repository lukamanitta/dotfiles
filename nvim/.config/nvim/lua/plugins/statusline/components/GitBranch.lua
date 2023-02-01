return {
    provider = function()
        local branch = require("utils.helpers").shell(
            "git rev-parse --abbrev-ref HEAD 2> /dev/null"
        )
        if branch == "" then
            return " "
                .. require("assets.icons").filesystem.Folder
                .. " "
                .. vim.fn.expand("%:p:h:t")
                .. " "
        end
        return " " .. require("assets.icons").git.Branch .. " " .. branch .. " "
    end,
    update = "VimEnter",
}
