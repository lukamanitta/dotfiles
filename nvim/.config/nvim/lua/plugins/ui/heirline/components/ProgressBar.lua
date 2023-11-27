return {
    static = {
        -- progress_indicator = { "▔", "🮂", "🮃", "▀", "🮄", "🮅", "🮆", "█" },
        progress_indicator = { "󰝦", "󰪞", "󰪟", "󰪠", "󰪡", "󰪢", "󰪣", "󰪤", "󰪥" },
    },
    provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local i = math.floor((curr_line - 1) / lines * #self.progress_indicator) + 1
        return string.rep(self.progress_indicator[i], 1) .. " "
    end,
}
