local iterations = 10000

vim.api.nvim_buf_set_lines(
    0,
    0,
    -1,
    false,
    vim.fn["repeat"]({ "local x = 1" }, 100)
)
vim.api.nvim_win_set_cursor(0, { 50, 0 })

local render = require("ui.statusline").render
local start = vim.uv.hrtime()
for _ = 1, iterations do
    render()
end
local elapsed_ms = (vim.uv.hrtime() - start) / 1e6
print(
    string.format(
        "statusline render x%d: %.2f ms (%.3f us/call)",
        iterations,
        elapsed_ms,
        elapsed_ms * 1000 / iterations
    )
)

local diag_start = vim.uv.hrtime()
for _ = 1, iterations do
    for _, sev in ipairs({ "ERROR", "WARN", "INFO", "HINT" }) do
        vim.diagnostic.get(nil, { severity = vim.diagnostic.severity[sev] })
    end
end
local diag_ms = (vim.uv.hrtime() - diag_start) / 1e6
print(
    string.format(
        "4x diagnostic.get(nil) x%d: %.2f ms (%.3f us/call)",
        iterations,
        diag_ms,
        diag_ms * 1000 / iterations
    )
)
