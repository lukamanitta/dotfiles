local b = vim.b
local api, cmd = vim.api, vim.cmd
local F = {}

function F.open_file_in_prev_window()

end

function F.trim_whitespace()
    local cursor_pos = api.nvim_win_get_cursor(0)
    cmd 'keeppatterns %s/\\s\\+$//e'
    api.nvim_win_set_cursor(0,cursor_pos)
end

function F.startup_layout()
    cmd 'split | resize 10 | execute "term" | wincmd p'
end

-- Background Terminals
Term_Buf_List = {}
function F.set_term_buffer(id)
    if b['terminal_job_id'] == nil then
        cmd 'echo "You must be in a terminal to execute this command"'
        return
    end

    if id > 4 or id < 0 then
        cmd 'echo "id must be between 0 and 4"'
        return
    end

    Term_Buf_List[id] = { b['terminal_job_id'], api.nvim_win_get_buf(0) }
end

function F.open_term_buffer(id)
    if id > 4 or id < 0 then
        cmd 'echo "id must be between 0 and 4"'
        return
    end

    local buffer = Term_Buf_List[id]

    if buffer == nil then
        cmd 'echo "Nothing there"'
        return
    end

    local buffer_handle = buffer[1]
    api.nvim_win_set_buf(0, buffer_handle)
end

return F
