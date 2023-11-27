-- TODO: big refactor here
local Set = require("utils.collections.Set")
local table_has_value = require("helpers").table_has_value

return {
    provider = function()
        local icon = "  "

        local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
        local clients = vim.lsp.get_active_clients() -- TODO: maybe this isn't working?

        if next(clients) == nil then
            return " " .. icon .. "No Active LSP" .. " "
        end

        local client_names = Set:new()
        for _, client in ipairs(clients) do
            if table_has_value(client.config.filetypes, buf_ft) then
                client_names:add(client.name)
            end
        end

        if client_names:size() < 2 then
            return " " .. icon .. "No Active LSP" .. " "
        end

        if client_names:contains("null-ls") and client_names:size() > 1 then
            client_names:remove("null-ls")
        end

        return " " .. icon .. client_names:to_string() .. " "
    end,
    update = {
        "LspAttach",
        "LspDetach",
    },
}
