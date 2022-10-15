---@diagnostic disable:undefined-global
local shell = require("utils.helpers").shell

return {
    s(
        "note",
        fmt(
            [[
    ---
    course: {}
    date: {}
    ---

    # {}
    ]]       ,
            {
                shell("pwd | egrep -o '[A-Z]{4}[0-9]{4}' | tail -1"),
                shell("date +%Y/%m/%d"),
                i(0, "Title"),
            }
        )
    ),
}
