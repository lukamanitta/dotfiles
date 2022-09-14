---@diagnostic disable:undefined-global

return {
    s("fn", {
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
        i(3, "func_name"),
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
