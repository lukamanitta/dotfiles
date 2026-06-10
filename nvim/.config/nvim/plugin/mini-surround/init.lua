vim.pack.add({
    { src = "https://github.com/nvim-mini/mini.surround" },
})

require("mini.surround").setup({
    mappings = {
        delete = "ds",
        replace = "cs",
    },
    custom_surroundings = {
        b = {
            input = function()
                -- Use Tree-sitter to find the surrounding if_statement node
                local node = vim.treesitter.get_node()
                while node and node:type() ~= "if_statement" do
                    node = node:parent()
                end
                if not node then
                    return nil
                end

                -- Get the exact range of the if statement structure
                local range = { node:range() }

                -- Define the parts to delete (the wrapper) vs the code to keep
                -- Note: Adjust based on your language's specific TS node structure
                return {
                    first = {
                        from = { line = range[1] + 1, col = range[2] + 1 },
                        to = { line = range[1] + 1, col = range[4] },
                    },
                    -- This captures the closing structure (like an 'end' or '}')
                    last = {
                        from = { line = range[3] + 1, col = 0 },
                        to = { line = range[3] + 1, col = range[4] },
                    },
                }
            end,
        },
    },
})
