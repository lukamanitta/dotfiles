local conditions = require("heirline.conditions")
local lsp_icons = require("icons").lsp
local get_hl = require("helpers").get_hl
local BubbleThis = require("plugins.ui.heirline.components.BubbleThis")
local SingleSpace = require("plugins.ui.heirline.components.SingleSpace")

local function create_diagnostic_component(severity)
    return {
        -- condition = function()
        --     return #vim.diagnostic.get(0, {
        --         severity = vim.diagnostic.severity[string.upper(severity)],
        --     }) > 0
        -- end,
        condition = conditions.has_diagnostics,

        provider = function()
            local count = #vim.diagnostic.get(0, {
                severity = vim.diagnostic.severity[string.upper(severity)],
            })
            local last_space = severity == "Hint" and "" or " "
            return lsp_icons[severity] .. " " .. count .. last_space
        end,
        hl = {
            bg = get_hl("Diagnostic" .. severity, "fg#"),
            fg = get_hl("StatusLine", "bg#"),
        },
    }
end

return {
    update = { "DiagnosticChanged", "BufEnter" },
    BubbleThis(
        {
            condition = conditions.has_diagnostics,
            create_diagnostic_component("Error"),
            SingleSpace({ bg = get_hl("DiagnosticWarn", "fg#") }),
            create_diagnostic_component("Warn"),
            SingleSpace({ bg = get_hl("DiagnosticInfo", "fg#") }),
            create_diagnostic_component("Info"),
            SingleSpace({ bg = get_hl("DiagnosticHint", "fg#") }),
            create_diagnostic_component("Hint"),
        }
    ),
    SingleSpace("StatusLine"),
}
