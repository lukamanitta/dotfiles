local conform = require("conform")

conform.setup({
    format_on_save = {
        lsp_fallback = true,
        timeout_ms = 500,
    },
})

-- Installation: cargo install stylua
conform.formatters_by_ft.lua = { "stylua" }
conform.formatters.stylua = {
    prepend_args = {
        "--config-path",
        vim.fn.expand("~/.config/nvim/.stylua.toml"),
    },
}

-- Installation: *comes with rust toolchain*
conform.formatters_by_ft.rust = { "rustfmt" }

-- Installation: gem install rubocop
conform.formatters_by_ft.ruby = { "rubocop" }

-- Installation: pip3 install "gdtoolkit==4.*"
conform.formatters_by_ft.gdscript = { "gdformat" }

-- Installation: npm install -g eslint_d
for _, ft in ipairs({
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
}) do
    conform.formatters_by_ft[ft] = { "eslint_d" }
end

-- Installation: npm install -g @fsouza/prettierd
for _, ft in ipairs({ "html", "css", "scss", "json", "svelte" }) do
    conform.formatters_by_ft[ft] = { "prettierd" }
end

-- Format embedded languages in different filetypes
conform.formatters_by_ft["*"] = { "injected" }
