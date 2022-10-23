local cmd = vim.cmd
local cmp = require("cmp")
local compare = require("cmp.config.compare")
local tabnine = require("cmp_tabnine.config")
local comp_icons = require("assets.icons").types

local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0
        and vim.api
        .nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]
        :match("^%s*$")
        == nil
end

cmp.setup.filetype({ "markdown" }, {
    sources = cmp.config.sources({
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "latex_symbols", max_item_count = 10 },
        { name = "spell", max_item_count = 3 },
        { name = "buffer" },
    }, {
        { name = "path", max_item_count = 5 },
    }),
})

cmp.setup.filetype({ "gitcommit" }, {
    sources = cmp.config.sources({
        { name = "conventionalcommits" },
        { name = "spell", max_item_count = 3 },
    }),
})

local luasnip = require("luasnip")

require("copilot_cmp").setup({
    method = "getCompletionsCycling", -- or "getPanelCompletions"
    formatters = {
        insert_text = require("copilot_cmp.format").remove_existing,
    },
})

cmp.setup({
    -- completion = {
    --     autocomplete = true,
    -- },
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
                fallback()
            end
        end),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ["<C-Space>"] = cmp.mapping.confirm({ select = true }), -- Control-Space to confirm
        ["<C-j>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
        ["<C-k>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
        ["<C-l>"] = cmp.mapping(function()
            if luasnip.choice_active() then
                luasnip.change_choice(1)
            end
        end, {
            "i",
        }),
    },
    sources = cmp.config.sources({
        { name = "luasnip" },
        { name = "copilot" },
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lsp", max_item_count = 5 },
        { name = "nvim_lua", max_item_count = 5 },
        -- { name = "cmp_tabnine" },
        { name = "buffer", keyword_length = 5, max_item_count = 5 },
        { name = "omni" },
    }, {
        { name = "path" },
    }),
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            if entry.source.name == "cmp_tabnine" then
                vim_item.kind = "Tabnine"
            elseif entry.source.name == "spell" then
                vim_item.kind = "Spell"
            elseif entry.source.name == "latex_symbols" then
                vim_item.kind = "Latex"
            elseif entry.source.name == "conventionalcommits" then
                vim_item.kind = "CommitMsg"
            elseif entry.source.name == "copilot" then
                vim_item.kind = "Copilot"
            elseif entry.source.source.client ~= nil then
                if entry.source.source.client.name == "zk"
                    and vim_item.kind == "Text"
                then
                    vim_item.kind = "Tag"
                end
            end

            -- Display appropriate icons
            -- vim_item.kind = string.format("%s %s", comp_icons[vim_item.kind], vim_item.kind)
            vim_item.kind = string.format("%s ", comp_icons[vim_item.kind])

            -- Display source of completion
            vim_item.menu = ({
                buffer = "[Buffer]",
                path = "[Path]",
                nvim_lsp = "[LSP]",
                ultisnips = "[UltiSnips]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
                latex_symbols = "[LaTeX]",
                cmp_tabnine = "[TN]",
                spell = "[Spell]",
                omni = "[Omni]",
                conventionalcommits = "[CommitMsg]",
                copilot = "[Copilot]",
            })[entry.source.name]
            return vim_item
        end,
    },
    sorting = {
        priority_weight = 1,
        comparators = {
            compare.exact,
            require("copilot_cmp.comparators").prioritize,
            require("copilot_cmp.comparators").score,
            compare.offset,
            compare.score,
            compare.recently_used,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
        },
    },
    view = {
        entries = cmp.EntriesConfig,
    },
    experimental = {
        ghost_text = false,
    },
})

-- tabnine:setup({
--     max_lines = 1000,
--     max_num_results = 20,
--     sort = true,
--     run_on_every_keystroke = true,
--     snippet_placeholder = "..",
--     ignored_file_types = {},
-- })
