local success_icon = require("icons").general.Pencil .. " "
local failure_icon = require("icons").general.PencilOff .. " "
local get_hl = require("helpers").get_hl

local function null_ls_active()
    local clients = vim.lsp.get_clients({
        bufnr = 0,
    })

    for _, client in ipairs(clients) do
        if client.name == "null-ls" then
            return true
        end
    end
    return false
end

return {
    provider = function()
        if null_ls_active() then
            return success_icon
        end
        return failure_icon
    end,
    hl = function()
        return {
            fg = null_ls_active() and get_hl("DiagnosticOk", "fg#") or get_hl("Comment", "fg#"),
            bg = get_hl("BarHighlight2", "bg#")
        }
    end,
    update = {
        "LspAttach",
        "LspDetach",
    },
}
