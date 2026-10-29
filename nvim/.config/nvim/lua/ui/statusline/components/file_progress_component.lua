-- local progress_indicator = { "▔", "🮂", "🮃", "▀", "🮄", "🮅", "🮆", "█" }
local progress_indicator =
    { "󰝦", "󰪞", "󰪟", "󰪠", "󰪡", "󰪢", "󰪣", "󰪤", "󰪥" }

return function()
    local line_count = vim.api.nvim_buf_line_count(0)
    if line_count == 0 then
        return progress_indicator[1] .. " "
    end

    local line = math.min(vim.api.nvim_win_get_cursor(0)[1], line_count)
    local i = math.floor((line - 1) / line_count * #progress_indicator) + 1
    i = math.max(1, math.min(#progress_indicator, i))

    return progress_indicator[i] .. " "
end
