local U = {}
local fn = vim.fn

function U.get_hi_group_bg(hi_group)
    return fn.synIDattr(fn.synIDtrans(fn.hlID(hi_group)), "bg#")
end

function U.get_hi_group_fg(hi_group)
    return fn.synIDattr(fn.synIDtrans(fn.hlID(hi_group)), "fg#")
end

return U
