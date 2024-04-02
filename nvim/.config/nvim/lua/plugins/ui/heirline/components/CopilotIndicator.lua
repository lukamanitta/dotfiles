local success_icon = require("icons").types.Copilot .. " "
local failure_icon = require("icons").types.CopilotWarn .. " "
local get_hl = require("helpers").get_hl

local function copilot_active()
    local clients = vim.lsp.get_clients({
        bufnr = 0,
    })

    for _, client in ipairs(clients) do
        if client.name == "copilot" then
            return true
        end
    end
    return false
end

return {
    provider = function()
        if copilot_active() then
            return success_icon
        end
        return failure_icon
    end,
    hl = function()
        return {
            fg = copilot_active() and get_hl("DiagnosticOk", "fg#") or get_hl("Comment", "fg#"),
            bg = get_hl("BarHighlight2", "bg#")
        }
    end,
    update = {
        "LspAttach",
        "LspDetach",
    },
}