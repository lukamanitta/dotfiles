vim.keymap.set("n", "<LEADER>db", function()
    require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })

vim.keymap.set("n", "<LEADER>dc", function()
    require("dap").continue()
end, { desc = "Continue" })

vim.keymap.set("n", "<LEADER>dC", function()
    require("dap").run_to_cursor()
end, { desc = "Run to Cursor" })

vim.keymap.set("n", "<LEADER>dT", function()
    require("dap").terminate()
end, { desc = "Terminate" })
