---@diagnostic disable:undefined-global

local addPropsToName = function(node_id)
    return fn(function(args)
        return args[1][1] .. "Props"
    end, { node_id })
end

return {
    s(
        "functional-component",
        fmt(
            [[
    interface {} {{
        {};
    }}

    function {}({{ {} }}: {}) {{
      return (
        {}
      );
    }}

    export default {}
    ]]       ,
            {
                addPropsToName(1),
                i(3, "arg1: type"),
                i(1, "ComponentName"),
                i(2, "props"),
                addPropsToName(1),
                i(0),
                rep(1),
            }
        )
    ),
}
