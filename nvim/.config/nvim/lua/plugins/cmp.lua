local cmp = require('cmp')

local comp_icons = {
    Color = ' ',
    Constant = ' ',
    EnumMember = ' ',
    Field = ' ',
    Folder = ' ',
    Function = ' ',
    Keyword = ' ',
    Method = ' ',
    Module = ' ',
    Property = ' ',
    Struct = ' ',
    Text = ' ',
    Value = ' ',
    Variable = ' ',
    Constructor = '',
    Class = 'ﴯ',
    Interface = '',
    Unit = '',
    Enum = '',
    Snippet = '',
    File = '',
    Reference = '',
    Event = '',
    Operator = '',
    TypeParameter = '',
}

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn['UltiSnips#Anon'](args.body)
        end,
    },
    mapping = {
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<C-M>'] = cmp.mapping.confirm({ select = true }), -- Control-Enter to confirm
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'ultisnips' },
        { name = 'buffer' },
        { name = 'path' },
    }),
    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = string.format('%s %s', comp_icons[vim_item.kind], vim_item.kind)
            -- Source
            vim_item.menu = ({
                buffer = '[Buffer]',
                nvim_lsp = '[LSP]',
                luasnip = '[LuaSnip]',
                nvim_lua = '[Lua]',
                latex_symbols = '[LaTeX]',
            })[entry.source.name]
            return vim_item
        end,
    },
})
