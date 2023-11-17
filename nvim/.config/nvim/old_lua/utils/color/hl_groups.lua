local U = {}
local fn = vim.fn

function U.get_hi_group_bg(hi_group)
    return fn.synIDattr(fn.synIDtrans(fn.hlID(hi_group)), "bg#")
end

function U.get_hi_group_fg(hi_group)
    return fn.synIDattr(fn.synIDtrans(fn.hlID(hi_group)), "fg#")
end

function U.remove_hl_bg(hi_group)
    local command = "hi! " .. hi_group .. " guibg=NONE"
    if U.get_hi_group_fg(hi_group) ~= "" then
        command = command .. " guifg=" .. U.get_hi_group_fg(hi_group)
    end
    vim.cmd(command)
end

return U
