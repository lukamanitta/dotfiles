-- local progress_indicator = { "▔", "🮂", "🮃", "▀", "🮄", "🮅", "🮆", "█" }
local progress_indicator =
    { "󰝦", "󰪞", "󰪟", "󰪠", "󰪡", "󰪢", "󰪣", "󰪤", "󰪥" }

return function()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local line_count = vim.api.nvim_buf_line_count(0)
    local i = math.floor((line - 1) / line_count * #progress_indicator) + 1

    return progress_indicator[i] .. " "
end
