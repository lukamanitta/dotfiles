return {
    {
        "<LEADER>db",
        function()
            require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
    },

    {
        "<LEADER>dc",
        function()
            require("dap").continue()
        end,
        desc = "Continue",
    },

    {
        "<LEADER>dC",
        function()
            require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
    },

    {
        "<LEADER>dT",
        function()
            require("dap").terminate()
        end,
        desc = "Terminate",
    },
}
