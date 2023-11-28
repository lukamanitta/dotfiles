local cmp = require("cmp")
local compare = require("cmp.config.compare")
local comp_icons = require("icons").types

cmp.setup.filetype({ "markdown" }, {
    sources = cmp.config.sources({
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "latex_symbols", max_item_count = 10 },
        -- { name = "emoji", trigger_characters = { "@" }, max_item_count = 5 },
        -- { name = "spell", max_item_count = 3 },
        { name = "buffer" },
    }, {
        { name = "path", max_item_count = 5 },
    }),
})

local luasnip = require("luasnip")

-- require("copilot_cmp").setup({
--     method = "getCompletionsCycling", -- or "getPanelCompletions"
--     formatters = {
--         insert_text = require("copilot_cmp.format").remove_existing,
--     },
-- })

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<Tab>"] = cmp.mapping.select_next_item(),
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
        { name = "luasnip", max_item_count = 3 },
        -- { name = "copilot" },
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lsp", max_item_count = 10 },
        { name = "nvim_lua", max_item_count = 5 },
        { name = "buffer", keyword_length = 5, max_item_count = 5 },
    }, {
        { name = "path" },
    }),
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            if entry.source.name == "spell" then
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
            vim_item.kind = string.format(" %s  ", comp_icons[vim_item.kind])

            -- Display source of completion
            vim_item.menu = ({
                buffer = "[Buffer]",
                path = "[Path]",
                nvim_lsp = "[LSP]",
                ultisnips = "[UltiSnips]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
                latex_symbols = "[LaTeX]",
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
            -- require("copilot_cmp.comparators").prioritize,
            -- require("copilot_cmp.comparators").score,
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
        entries = {
            vertical_positioning = "above",
        }
    },
    window = {
        completion = { side_padding = 0 },
    },
    experimental = {
        ghost_text = false,
    },
})

require("plugins.cmp.custom_hl")
-- require("plugins.plugin").keybinds
