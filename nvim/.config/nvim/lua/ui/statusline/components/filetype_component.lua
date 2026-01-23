return function()
    local icon, icon_hl = require("h").get_buf_icon()

    return string.format(
        "%%#%s#%s %%#Statusline#%s",
        icon_hl,
        icon,
        require("h").get_buf_filetype()
    )

    -- return table.concat({
    --     require("h").get_buf_icon(),
    --     " ",
    --     require("h").get_buf_filetype(),
    -- })
end
