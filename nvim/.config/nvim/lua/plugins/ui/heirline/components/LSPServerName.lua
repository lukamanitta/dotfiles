local Set = require("lib.collections.Set")

return {
    provider = function()
        local icon = "  "

        local clients = vim.lsp.get_clients({
            bufnr = 0,
        })

        local client_names = Set:new()
        for _, client in ipairs(clients) do
            client_names:add(client.name)
        end

        if client_names:contains("null-ls") then
            client_names:remove("null-ls")
        end
        if client_names:contains("copilot") then
            client_names:remove("copilot")
        end

        if client_names:is_empty() then
            return " " .. icon .. "No Active LSP" .. " "
        end

        return " " .. icon .. client_names:to_string() .. " "
    end,
    update = {
        "LspAttach",
        "LspDetach",
    },
}