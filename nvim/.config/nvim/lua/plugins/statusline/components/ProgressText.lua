return {
    provider = function()
        local cur = vim.fn.line(".")
        local total = vim.fn.line("$")
        if cur == 1 then
            return "Top"
        elseif cur == total then
            return "Bot"
        else
            return math.floor(cur / total * 100)
                .. require("assets.icons").general.Percent
        end
    end,
}
