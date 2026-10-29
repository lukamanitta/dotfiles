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
        vim.hl.hl_op({ higroup = "IncSearch", timeout = 300 })
    end,
})

-- Close terminal buffer when terminal process exits
vim.cmd(
    "autocmd TermClose * if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif"
)

if vim.g.is_hypr_scratch == 1 then
    local LINE_HEIGHT = 25
    local WINDOW_PADDING = LINE_HEIGHT * 3
    local MIN_HEIGHT = (6 * LINE_HEIGHT) + WINDOW_PADDING
    local MAX_HEIGHT = (30 * LINE_HEIGHT) + WINDOW_PADDING
    local MAX_VISUAL_LINES =
        math.floor((MAX_HEIGHT - WINDOW_PADDING) / LINE_HEIGHT)
    local WINDOW_SELECTOR = "title:^scratch$"

    local last_visual_lines
    local pending_height
    local resize_in_flight = false
    local resize_failed = false

    local function resize_window(height)
        if resize_in_flight then
            pending_height = height
            return
        end

        resize_in_flight = true

        local code = string.format(
            'local w = hl.get_window("%s"); if not w then return end; hl.dispatch(hl.dsp.window.resize({ x = w.size.x, y = %d, relative = false, window = "%s" })); hl.dispatch(hl.dsp.window.center({ window = "%s" }))',
            WINDOW_SELECTOR,
            height,
            WINDOW_SELECTOR,
            WINDOW_SELECTOR
        )

        local ok, spawn_err = pcall(
            vim.system,
            { "hyprctl", "eval", code },
            { text = true },
            function(result)
                vim.schedule(function()
                    resize_in_flight = false

                    if result.code ~= 0 and not resize_failed then
                        resize_failed = true
                        vim.notify(
                            "Scratch resize failed: " .. (result.stderr or ""),
                            vim.log.levels.WARN,
                            { title = "Scratch" }
                        )
                    end

                    if pending_height then
                        local next_height = pending_height
                        pending_height = nil
                        resize_window(next_height)
                    end
                end)
            end
        )

        if not ok then
            resize_in_flight = false
            if not resize_failed then
                resize_failed = true
                vim.notify(
                    "Scratch resize failed: " .. tostring(spawn_err),
                    vim.log.levels.WARN,
                    { title = "Scratch" }
                )
            end
        end
    end

    local function update_size()
        local ok, text_height = pcall(
            vim.api.nvim_win_text_height,
            0,
            { start_row = 0, max_height = MAX_VISUAL_LINES }
        )
        if not ok then
            return
        end

        local visual_lines = text_height.all
        if visual_lines == last_visual_lines then
            return
        end

        last_visual_lines = visual_lines

        local new_height = (visual_lines * LINE_HEIGHT) + WINDOW_PADDING
        new_height = math.max(MIN_HEIGHT, math.min(MAX_HEIGHT, new_height))

        resize_window(new_height)
    end

    vim.api.nvim_create_autocmd(
        { "BufEnter", "TextChanged", "TextChangedI", "VimResized" },
        {
            group = vim.api.nvim_create_augroup(
                "hypr_scratch_resize",
                { clear = true }
            ),
            callback = update_size,
        }
    )
end
