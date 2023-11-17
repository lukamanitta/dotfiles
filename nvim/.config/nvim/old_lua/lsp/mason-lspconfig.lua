local table_merge = require("utils.tables").table_merge
local U = {}

U.on_attach = function(client, bufnr)
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
    buf_set_keymap(
        "n",
        "]e",
        ":lua vim.diagnostic.goto_next({float=false})<CR>",
        opts
    )
    buf_set_keymap(
        "n",
        "[e",
        ":lua vim.diagnostic.goto_prev({float=false})<CR>",
        opts
    )
    buf_set_keymap(
        "n",
        "<leader>d",
        ":lua vim.diagnostic.open_float({ scope = 'c' })<CR>",
        opts
    )
end

-- Config that activates keymaps and enables snippet support
local function make_config()
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return {
        -- Enable snippet support
        capabilities = capabilities,
        -- Map buffer local keybindings when the language server attaches
        on_attach = U.on_attach,
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
    ["lua_ls"] = function()
        local config = make_config()
        config.settings = lua_settings
        require("lspconfig")["lua_ls"].setup(config)
        vim.cmd([[ do User LspAttachBuffers ]])
    end,
    ["emmet_ls"] = function()
        local config = make_config()
        config.filetypes = { "html", "css", "javascript", "javascriptreact" }
        require("lspconfig")["emmet_ls"].setup(config)
        vim.cmd([[ do User LspAttachBuffers ]])
    end,
    ["jdtls"] = function()
        local config = make_config()
        local home = os.getenv("HOME")
        local root_markers = { "pom.xml", "build.gradle", ".git" }
        local root_dir = require("lspconfig.util").root_pattern(root_markers)
        local workspace_folder = home
            .. "/.local/share/eclipse/"
            .. vim.fn.fnamemodify(root_dir(vim.fn.getcwd()), ":p:h:t")

        config.cmd = {
            "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xms4g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",

            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",

            "-jar",
            vim.fn.stdpath("data")
                .. "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",

            "-configuration",
            vim.fn.stdpath("data") .. "/mason/packages/jdtls/config_mac",

            "-data",
            workspace_folder,
        }

        config.root_dir = root_dir

        config.configuration = {
            runtimes = {
                {
                    name = "JavaSE-17",
                    path = home .. "/.asdf/installs/java/openjdk-17.0.2",
                },
            },
        }

        config.settings = {
            -- java = {
            --     signatureHelp = { enabled = true },
            --     contentProvider = { preferred = "fernflower" },
            --     sources = {
            --         organizeImports = {
            --             starThreshold = 9999,
            --             staticStarThreshold = 9999,
            --         },
            --     },
            -- },
        }
        require("lspconfig")["jdtls"].setup(config)
        vim.cmd([[ do User LspAttachBuffers ]])
    end,
})

return U
