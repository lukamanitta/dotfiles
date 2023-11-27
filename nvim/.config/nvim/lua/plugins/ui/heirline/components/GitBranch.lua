return {
    provider = function()
        local branch = require("helpers").shell(
            "git rev-parse --abbrev-ref HEAD 2> /dev/null"
        )
        return " " .. require("icons").git.Branch .. " " .. branch .. " "
    end,
    update = "VimEnter",
}
