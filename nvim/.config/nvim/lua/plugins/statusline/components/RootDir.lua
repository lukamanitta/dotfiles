return {
    provider = function()
        return " "
            .. require("assets.icons").filesystem.Folder
            .. " "
            .. vim.fn.expand("%:p:h:t")
            .. " "
    end,
    update = "VimEnter",
}
