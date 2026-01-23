return function(side, opts)
    local char = side == "left" and "" or ""
    return vim.tbl_deep_extend("force", { provider = char }, opts)
end
