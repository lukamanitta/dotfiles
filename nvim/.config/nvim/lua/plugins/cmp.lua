local cmd = vim.cmd
local cmp = require('cmp')
local compare = require('cmp.config.compare')
local tabnine = require('cmp_tabnine.config')
local comp_icons = require('assets.icons').comp_types

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

cmp.setup({
    preselect = cmp.PreselectMode.None,
    completion = {
        autocomplete = false,
    },
    snippet = {
        expand = function(args)
            vim.fn['UltiSnips#Anon'](args.body)
        end,
    },
    mapping = {
        ['<Tab>'] = {
            i = function(_)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    cmp.complete()
                    -- vim.api.nvim_feedkeys(t('<Tab>'), 'n', true) -- fallback()
                end
            end,
        },
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        -- ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<C-Space>'] = cmp.mapping.confirm({ select = true }), -- Control-Space to confirm
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'cmp_tabnine' },
        { name = 'ultisnips' },
    }),
    formatting = {
        format = function(entry, vim_item)
            if entry.source.name == 'cmp_tabnine' then
                vim_item.kind = 'Tabnine'
            end
            -- Display appropriate icons
            vim_item.kind = string.format('%s %s', comp_icons[vim_item.kind], vim_item.kind)

            -- Display source of completion
            vim_item.menu = ({
                buffer = '[Buffer]',
                nvim_lsp = '[LSP]',
                luasnip = '[LuaSnip]',
                nvim_lua = '[Lua]',
                latex_symbols = '[LaTeX]',
                cmp_tabnine = '[TN]',
            })[entry.source.name]
            return vim_item
        end,
    },
    sorting = {
        priority_weight = 1,
        comparators = {
            require('cmp_tabnine.compare'),
            compare.offset,
            compare.exact,
            compare.score,
            compare.recently_used,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
        },
    },
    experimental = {
        native_menu = true,
        ghost_text = false,
    },
})

tabnine:setup({
    max_lines = 1000,
    max_num_results = 20,
    sort = true,
    run_on_every_keystroke = true,
    snippet_placeholder = '..',
    ignored_file_types = {},
})
