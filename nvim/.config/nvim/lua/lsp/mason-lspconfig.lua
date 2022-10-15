local table_merge = require("utils.config").table_merge

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings
    local opts = { noremap = true, silent = true }

    -- Built-in LSP
    buf_set_keymap("n", "gD", ":lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", ":lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "gi", ":lua vim.lsp.buf.implementation()<CR>", opts)

    -- Actions
    buf_set_keymap(
        "n",
        "<leader>ca",
        ":lua vim.lsp.buf.code_action()<CR>",
        opts
    )
    buf_set_keymap("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap(
        "n",
        "<leader>sh",
        ":lua vim.lsp.buf.signature_help()<CR>",
        opts
    )
    buf_set_keymap("n", "]e", ":lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "[e", ":lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap(
        "n",
        "<leader>d",
        ":lua vim.diagnostic.open_float({ scope = 'c' })<CR>",
        opts
    )

    -- Trouble
    buf_set_keymap("n", "gr", ":Trouble lsp_references<CR>", opts)
    buf_set_keymap(
        "n",
        "<leader>xw",
        ":Trouble workspace_diagnostics<CR>",
        opts
    )
    buf_set_keymap("n", "<leader>xd", ":Trouble document_diagnostics<CR>", opts)
end

-- Config that activates keymaps and enables snippet support
local function make_config()
    local capabilities = require("cmp_nvim_lsp").update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
    )
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return {
        -- Enable snippet support
        capabilities = capabilities,
        -- Map buffer local keybindings when the language server attaches
        on_attach = on_attach,
    }
end

local lua_settings = {
    Lua = {
        runtime = {
            -- LuaJIT in the case of Neovim
            version = "LuaJIT",
            path = vim.split(package.path, ";"),
        },
        diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim", "use" },
            disable = { "trailing-space" },
        },
        workspace = {
            -- Make the server aware of Neovim runtime files
            library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
            },
        },
        completion = {
            keywordSnippet = "Replace",
            callSnippet = "Replace",
        },
    },
}

require("neodev").setup({
    library = {
        enabled = true,
        runtime = true,
        types = true,
        plugins = { "nvim-treesitter", "telescope.nvim" },
    },
})

require("mason-lspconfig").setup_handlers({
    function(server_name)
        require("lspconfig")[server_name].setup(make_config())
        vim.cmd([[ do User LspAttachBuffers ]])
    end,

    ["sumneko_lua"] = function()
        local config = make_config()
        config.settings = lua_settings
        require("lspconfig")["sumneko_lua"].setup(config)
        vim.cmd([[ do User LspAttachBuffers ]])
    end,

    ["emmet_ls"] = function()
        local config = make_config()
        config.filetypes = { "html", "css", "javascript", "javascriptreact" }
        require("lspconfig")["emmet_ls"].setup(config)
        vim.cmd([[ do User LspAttachBuffers ]])
    end,
})
