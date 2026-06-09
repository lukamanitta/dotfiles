return {
    cmd = { "asdf", "exec", "ruby-lsp" },
    filetypes = { "ruby", "eruby" },
    root_markers = { "Gemfile", ".git" },
    init_options = {
        formatter = "rubocop",
        linters = { "rubocop" },
        addonSettings = {
            ["Ruby LSP Rails"] = {
                enablePendingMigrationsPrompt = true,
            },
        },
    },
}
