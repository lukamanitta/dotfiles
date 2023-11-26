return {
    provider = function()
        return " "
            .. require("icons").filesystem.Folder
            .. " "
            .. vim.fn.expand("%:p:h:t")
            .. " "
    end,
    update = "VimEnter",
}
