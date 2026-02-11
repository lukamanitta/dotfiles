require("plugins.debugging.configs")

vim.fn.sign_define("DapBreakpoint", {
    text = require("ui.icons").debug.Breakpoint,
    texthl = "DiagnosticSignError",
})
