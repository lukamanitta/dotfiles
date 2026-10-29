local icons = require("ui.icons").general
local hl = require("ui.statusline.hl")

local client_names = { "No Active LSP" }
local ignorelist = {
    "copilot",
    "GitHub Copilot",
}

vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach", "BufEnter" }, {
    group = vim.api.nvim_create_augroup("lsp_server_name", { clear = true }),
    callback = function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })

        client_names = {}
        for _, client in ipairs(clients) do
            if
                not vim.list_contains(client_names, client.name)
                and not vim.list_contains(ignorelist, client.name)
            then
                table.insert(client_names, client.name)
            end
        end

        if #client_names == 0 then
            client_names = { "No Active LSP" }
        end
    end,
})

return function()
    return hl.hl(
        "Comment",
        string.format("%s %s", icons.Gear, table.concat(client_names, ", "))
    )
end
