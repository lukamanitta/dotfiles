local GROUP = "ColorColumn"
local PATTERN = "\\%80v"
local PRIORITY = 100

local function add_match()
    local win = vim.api.nvim_get_current_win()
    if vim.api.nvim_win_get_config(win).relative ~= "" then
        return
    end

    for _, match in ipairs(vim.fn.getmatches(win)) do
        if match.group == GROUP and match.pattern == PATTERN then
            return
        end
    end

    vim.fn.matchadd(GROUP, PATTERN, PRIORITY)
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "WinNew" }, {
    group = vim.api.nvim_create_augroup("colorcolumn_match", { clear = true }),
    pattern = "*",
    callback = add_match,
})

vim.schedule(add_match)
