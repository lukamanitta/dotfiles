local cmd = vim.cmd
local cmp = require('cmp')
local compare = require('cmp.config.compare')
local tabnine = require('cmp_tabnine.config')
local comp_icons = require('assets.icons').comp_types

cmp.setup.filetype({ 'markdown' }, {
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'ultisnips' },
        { name = 'latex_symbols', max_item_count = 10 },
        { name = 'spell', max_item_count = 3 },
        { name = 'buffer' },
    }, {
        { name = 'path', max_item_count = 5 },
    }),
})

cmp.setup.filetype({ 'gitcommit' }, {
    sources = cmp.config.sources({
        { name = 'conventionalcommits' },
        { name = 'spell', max_item_count = 3 },
    }),
})

cmp.setup({
    -- completion = {
    --     autocomplete = true,
    -- },
    snippet = {
        expand = function(args)
            vim.fn['UltiSnips#Anon'](args.body)
            -- require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<Tab>'] = cmp.mapping.select_next_item(),
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
        { name = 'ultisnips' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'cmp_tabnine' },
        { name = 'buffer', keyword_length = 5, max_item_count = 5 },
        { name = 'omni' },
    }, {
        { name = 'path' },
    }),
    formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
            if entry.source.name == 'cmp_tabnine' then
                vim_item.kind = 'Tabnine'
            elseif entry.source.name == 'spell' then
                vim_item.kind = 'Spell'
            elseif entry.source.name == 'latex_symbols' then
                vim_item.kind = 'Latex'
            elseif entry.source.name == 'conventionalcommits' then
                vim_item.kind = 'CommitMsg'
            end

            -- Display appropriate icons
            -- vim_item.kind = string.format('%s %s', comp_icons[vim_item.kind], vim_item.kind)
            vim_item.kind = string.format('%s ', comp_icons[vim_item.kind])

            -- Display source of completion
            vim_item.menu = ({
                buffer = '[Buffer]',
                path = '[Path]',
                nvim_lsp = '[LSP]',
                ultisnips = '[UltiSnips]',
                luasnip = '[LuaSnip]',
                nvim_lua = '[Lua]',
                latex_symbols = '[LaTeX]',
                cmp_tabnine = '[TN]',
                spell = '[Spell]',
                omni = '[Omni]',
                conventionalcommits = '[CommitMsg]',
            })[entry.source.name]
            return vim_item
        end,
    },
    sorting = {
        priority_weight = 1,
        comparators = {
            -- require('cmp_tabnine.compare'),
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
    view = {
        entries = cmp.EntriesConfig,
    },
    experimental = {
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
