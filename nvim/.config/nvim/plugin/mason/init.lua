vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.pack.add({
    { src = "https://github.com/mason-org/mason.nvim" },
})

require("mason").setup({})

vim.pack.add({
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "svelte",
        "ts_ls",
        "clangd",
        "cmake",
    },
})
