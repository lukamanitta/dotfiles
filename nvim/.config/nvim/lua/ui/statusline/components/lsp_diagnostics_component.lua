local lsp_icons = require("ui.icons").lsp
local hl = require("ui.statusline.hl")

local SEVERITIES = {
    { key = "ERROR", name = "Error" },
    { key = "WARN", name = "Warn" },
    { key = "INFO", name = "Info" },
    { key = "HINT", name = "Hint" },
}

local counts = {
    Error = 0,
    Warn = 0,
    Info = 0,
    Hint = 0,
}

local function refresh(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if not vim.api.nvim_buf_is_valid(bufnr) then
        return
    end

    local result = vim.diagnostic.count(bufnr)
    for _, severity in ipairs(SEVERITIES) do
        counts[severity.name] = result[vim.diagnostic.severity[severity.key]]
            or 0
    end
end

local function refresh_current(args)
    local bufnr = (args and args.buf) or vim.api.nvim_get_current_buf()
    if bufnr == vim.api.nvim_get_current_buf() then
        refresh(bufnr)
    end
end

vim.api.nvim_create_autocmd({ "DiagnosticChanged", "BufEnter" }, {
    group = vim.api.nvim_create_augroup(
        "lsp_diagnostics_component",
        { clear = true }
    ),
    callback = refresh_current,
})

local function build_diagnostic_text(severity)
    local count = counts[severity]
    if count == 0 then
        return ""
    end

    local group = "DiagnosticSign" .. severity
    return hl.hl(group, string.format("%s %d ", lsp_icons[severity], count))
end

refresh()

return function()
    return table.concat({
        build_diagnostic_text("Error"),
        build_diagnostic_text("Warn"),
        build_diagnostic_text("Info"),
        build_diagnostic_text("Hint"),
    })
end
