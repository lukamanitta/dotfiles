local lsp_icons = require("ui.icons").lsp

local function build_diagnostic_text(severity)
    local count = #vim.diagnostic.get(
        nil,
        { severity = vim.diagnostic.severity[severity:upper()] }
    )
    if count == 0 then
        return ""
    end

    local hl = "DiagnosticSign" .. severity
    return string.format("%%#%s#%s %d %%*", hl, lsp_icons[severity], count)
end

return function()
    return table.concat({
        build_diagnostic_text("Error"),
        build_diagnostic_text("Warn"),
        build_diagnostic_text("Info"),
        build_diagnostic_text("Hint"),
    })
end
