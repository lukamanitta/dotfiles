local U = {}

function U.set_scope_opts(scope, opts)
    for k, v in pairs(opts) do
        scope[k] = v
    end
end

function U.get_hl(hl_name, prop)
    return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hl_name)), prop)
end

return U
