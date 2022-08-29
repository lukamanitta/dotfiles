---@diagnostic disable:undefined-global
local cdocsnip = function(args, _, old_state)
    -- !!! old_state is used to preserve user-input here. DON'T DO IT THAT WAY!
    -- Using a restoreNode instead is much easier.
    -- View this only as an example on how old_state functions.
    local nodes = {
        t({ "/*", " * " }),
        i(1, "A short description"),
        t({ "", "" }),
    }

    -- These will be merged with the snippet; that way, should the snippet be updated,
    -- some user input eg. text can be referred to in the new snippet.
    local param_nodes = {}

    if old_state then
        nodes[2] = i(1, old_state.descr:get_text())
    end
    param_nodes.descr = nodes[2]

    -- At least one param.
    if string.find(args[2][1], ", ") then
        vim.list_extend(nodes, { t({ " * ", "" }) })
    end

    local insert = 2
    for _, arg in ipairs(vim.split(args[2][1], ", ", true)) do
        -- Get actual name parameter.
        arg = vim.split(arg, " ", true)[2]
        if arg then
            local inode
            -- if there was some text in this parameter, use it as static_text
            -- for this new snippet.
            if old_state and old_state[arg] then
                inode = i(insert, old_state["arg" .. arg]:get_text())
            else
                inode = i(insert)
            end
            vim.list_extend(nodes, { t({ " * " .. arg .. ": " }), inode, t({ "", "" }) })
            param_nodes["arg" .. arg] = inode

            insert = insert + 1
        end
    end

    if args[1][1] ~= "void" then
        local inode
        if old_state and old_state.ret then
            inode = i(insert, old_state.ret:get_text())
        else
            inode = i(insert)
        end

        vim.list_extend(nodes, { t({ " * ", " * Returns: " }), inode, t({ "", "" }) })
        param_nodes.ret = inode
        insert = insert + 1
    end

    if vim.tbl_count(args[3]) ~= 1 then
        local exc = string.gsub(args[3][2], " throws ", "")
        local ins
        if old_state and old_state.ex then
            ins = i(insert, old_state.ex:get_text())
        else
            ins = i(insert)
        end
        vim.list_extend(nodes, { t({ " * ", " * Throws " .. exc .. ": " }), ins, t({ "", "" }) })
        param_nodes.ex = ins
        insert = insert + 1
    end

    vim.list_extend(nodes, { t({ " */" }) })

    local snip = sn(nil, nodes)
    -- Error on attempting overwrite.
    snip.old_state = param_nodes
    return snip
end

return {
    s("fn", {
        d(6, cdocsnip, { 2, 4, 5 }),
        t({ "", "" }),
        c(1, {
            t("public "),
            t("private "),
            t(""),
        }),
        c(2, {
            t("void"),
            t("int"),
            t("char"),
            t("char*"),
            t("bool"),
            t("long"),
            t("float"),
            t("double"),
            i(nil, ""),
        }),
        t(" "),
        i(3, "my_func"),
        t("("),
        i(4),
        t(")"),
        c(5, {
            t(""),
            sn(nil, {
                t({ "", " throws " }),
                i(1),
            }),
        }),
        t({ " {", "\t" }),
        i(0),
        t({ "", "}" }),
    }),
}
