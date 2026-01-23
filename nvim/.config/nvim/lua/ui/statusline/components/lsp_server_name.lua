local client_names = { "No Active LSP" }

vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
    callback = function()
        local table_has_value = require("h").table_has_value

        local clients = vim.lsp.get_clients({
            bufnr = 0,
        })

        local client_names_ignorelist = {
            "copilot",
            "GitHub Copilot",
        }
        client_names = {}
        for _, client in ipairs(clients) do
            if
                not table_has_value(client_names, client.name)
                and not table_has_value(client_names_ignorelist, client.name)
            then
                table.insert(client_names, client.name)
            end
        end

        if next(client_names) == nil then
            client_names = { "No Active LSP" }
        end
    end,
})

return function()
    return string.format(
        "%%#Comment#%s %s%%#StatusLine#",
        require("ui.icons").general.Gear,
        table.concat(client_names, ", ")
    )
end
