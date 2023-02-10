return {
    provider = function()
        local branch = require("utils.helpers").shell(
            "git rev-parse --abbrev-ref HEAD 2> /dev/null"
        )
        return " " .. require("assets.icons").git.Branch .. " " .. branch .. " "
    end,
    update = "VimEnter",
}
