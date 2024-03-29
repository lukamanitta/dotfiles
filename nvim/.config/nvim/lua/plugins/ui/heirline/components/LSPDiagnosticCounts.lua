local conditions = require("heirline.conditions")
local lsp_icons = require("icons").lsp
local get_hl = require("helpers").get_hl

local function create_diagnostic_component(severity)
    return {
        provider = function()
            local count = #vim.diagnostic.get(0, {
                severity = vim.diagnostic.severity[string.upper(severity)],
            })
            if count == 0 then
                return ""
            end
            return lsp_icons[severity] .. " " .. count .. " "
        end,
        hl = {
            fg = get_hl("Diagnostic" .. severity, "fg#"),
            bg = get_hl("StatusLine", "bg#"),
        },
    }
end

return {
    condition = conditions.has_diagnostics,

    update = { "DiagnosticChanged", "BufEnter" },

    create_diagnostic_component("Error"),
    create_diagnostic_component("Warn"),
    create_diagnostic_component("Info"),
    create_diagnostic_component("Hint"),
}
