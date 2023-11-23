local U = {}

function U.set_scope_opts(scope, opts)
    for k, v in pairs(opts) do
        scope[k] = v
    end
end

return U
