vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        if ev.data.spec.name == "LuaSnip" then
            vim.system({ "make", "install_jsregexp", "-C", ev.data.path })
                :wait()
            vim.notify(
                "luasnip built successfully",
                vim.log.levels.INFO,
                { title = "Pack" }
            )
        end
    end,
})

vim.pack.add({
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    {
        src = "https://github.com/L3MON4D3/LuaSnip",
        version = vim.version.range("2.x"),
    },
})

require("luasnip").config.setup({
    enable_autosnippets = true,
})

require("luasnip.loaders.from_vscode").lazy_load()

require("luasnip.loaders.from_vscode").lazy_load({
    paths = { vim.fn.stdpath("config") .. "/snippets" },
})

vim.pack.add({
    {
        src = "https://github.com/saghen/blink.cmp",
        version = vim.version.range("2.x"),
    },
})

require("blink.cmp").setup({
    snippets = { preset = "luasnip" },
    sources = {
        default = {
            "lsp",
            "path",
            "snippets",
            "buffer",
        },
    },
    keymap = {
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Esc>"] = { "cancel", "fallback" },

        ["<Tab>"] = {
            function(cmp)
                return cmp.select_next()
            end,
            "snippet_forward",
            "fallback",
        },
        ["<S-Tab>"] = {
            function(cmp)
                return cmp.select_prev()
            end,
            "snippet_backward",
            "fallback",
        },

        ["<Down>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "snippet_forward", "fallback" },
        ["<C-p>"] = { "snippet_backward", "fallback" },
        ["<C-up>"] = { "scroll_documentation_up", "fallback" },
        ["<C-down>"] = { "scroll_documentation_down", "fallback" },
    },
    completion = {
        menu = {
            max_height = 10,
            direction_priority = { "n", "s" },
        },
        list = {
            selection = {
                auto_insert = true,
                preselect = false,
            },
        },
        documentation = {
            window = {
                direction_priority = {
                    menu_north = { "e", "w", "n", "s" },
                    menu_south = { "e", "w", "n", "s" },
                },
            },
        },
    },
})

vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
})
