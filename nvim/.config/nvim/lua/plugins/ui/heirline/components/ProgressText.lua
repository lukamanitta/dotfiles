return {
    provider = function()
        local cur = vim.fn.line(".")
        local total = vim.fn.line("$")
        if cur == 1 then
            return "%-4(Top%)"
        elseif cur == total then
            return "%-4(Bot%)"
        else
            return "%-3("
                .. math.floor(cur / total * 100)
                .. " "
                .. require("icons").general.Percent
                .. "%) "
        end
    end,
}
