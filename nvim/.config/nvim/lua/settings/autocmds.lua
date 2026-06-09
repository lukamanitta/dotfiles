vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("jump_to_last_pos", {}),
    pattern = "*",
    callback = function()
        if
            vim.fn.line("'\"") > 1
            and vim.fn.line("'\"") <= vim.fn.line("$")
        then
            vim.cmd('normal! g`"')
        end
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("yank_highlight", {}),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
    end,
})

-- Close terminal buffer when terminal process exits
vim.cmd(
    "autocmd TermClose * if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif"
)

if vim.g.is_hypr_scratch == 1 then
    vim.g.last_line_count = nil
    vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
        callback = function()
            local line_count = vim.api.nvim_buf_line_count(0)
            if vim.g.last_line_count ~= line_count then
                vim.g.last_line_count = line_count
                local LINE_HEIGHT = 25
                local CELL_WIDTH = 9
                local WINDOW_PADDING = LINE_HEIGHT * 3

                local new_height = (line_count * LINE_HEIGHT) + WINDOW_PADDING

                local MIN_HEIGHT, MAX_HEIGHT =
                    (6 * LINE_HEIGHT) + WINDOW_PADDING,
                    (30 * LINE_HEIGHT) + WINDOW_PADDING

                -- Clamp
                new_height =
                    math.max(MIN_HEIGHT, math.min(MAX_HEIGHT, new_height))

                local WINDOW_NAME = "scratch"

                local scratch_width_str = vim.fn.system(
                    string.format(
                        "hyprctl -j clients | jq -r '.[] | select(.title == \"%s\") | .size[0]'",
                        WINDOW_NAME
                    )
                )
                local scratch_width = tonumber(scratch_width_str)

                -- Round to nearest multiple of CELL_WIDTH
                scratch_width = math.ceil(scratch_width / CELL_WIDTH)
                    * CELL_WIDTH

                vim.fn.system(
                    string.format(
                        "hyprctl --batch 'dispatch resizewindowpixel exact %d %d,title:^%s$ ; dispatch centerwindow'",
                        scratch_width,
                        new_height,
                        WINDOW_NAME
                    )
                )
            end
        end,
    })
end
