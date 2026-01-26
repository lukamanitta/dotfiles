local U = {}

function U.render()
    vim.api.nvim_set_hl(0, "Winbar", { link = "StatusLine" })
    local prefix = require("ui.icons").filesystem.Folder
    local filepath = vim.fn.expand("%:f")
    local separator = " %#StatusLine#"
        .. require("ui.icons").general.ArrowRight
        .. " %#Winbar#"

    if vim.api.nvim_win_get_width(0) < 50 then
        filepath = vim.fn.pathshorten(filepath, 2)
    end

    filepath = filepath:gsub("^/", "")

    return table.concat({
        "%#Winbar# ",
        prefix,
        "  ",
        table.concat(vim.split(filepath, "/"), separator),
    })
end

vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function(args)
        if
            not vim.api.nvim_win_get_config(0).zindex -- Not a floating window
            and vim.bo[args.buf].buftype == "" -- Normal buffer
            -- and vim.api.nvim_buf_get_name(args.buf) ~= "" -- Has a file name
            and not vim.wo[0].diff -- Not in diff mode
        then
            vim.wo.winbar = "%{%v:lua.require'ui.winbar'.render()%}"
        end
    end,
})

return U
