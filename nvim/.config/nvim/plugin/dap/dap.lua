vim.pack.add({
    { src = "https://github.com/mfussenegger/nvim-dap" },
})

vim.fn.sign_define("DapBreakpoint", {
    text = require("ui.icons").debug.Breakpoint,
    texthl = "DiagnosticSignError",
})
