local map = require('utils.config').map
-- local api = vim.api
local cmd = vim.cmd
local g = vim.g

local silentnoremap = { silent = true, noremap = true }

-- Map <leader> to space
map('n', '<Space>', '<Nop>')
-- Mapleader
g.mapleader = ' '

-- Map jk to leave ins mode
map('i', 'jk', '<Esc>', silentnoremap)
map('', ';', ':', silentnoremap)

-- Reload config
map('n', '<leader>config', ':Reload<CR>')

-- Switch to alternate file
map('n', '<leader>a', '<C-^>')

-- <leader> + direction for window navigation
map('', '<leader>h', ':wincmd h<CR>')
map('', '<leader>j', ':wincmd j<CR>')
map('', '<leader>k', ':wincmd k<CR>')
map('', '<leader>l', ':wincmd l<CR>')

-- Make capital Y yanking work consistently with other capital letters
map('n', 'Y', 'y$')

-- Keep cursor centered when cycling through search results
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- Clear search highlight
map('', '//', ':nohlsearch<CR>')

-- Leave ins mode in terminal
map('t', 'jk', '<C-\\><C-n>')

-- Open NvimTree
map('n', '<leader>e', ':NvimTreeToggle<CR>')

-- TODO: Make this prettier
-- Telescope
map(
    'n',
    '<leader>ff',
    ':lua require("plugins.telescope.tele_utils").smart_file_finder(require("plugins.telescope.tele_utils").smart_theme_picker({}))<CR>',
    { silent = true }
)
map(
    'n',
    '<leader>fg',
    ':lua require("telescope.builtin").live_grep(require("plugins.telescope.tele_utils").smart_theme_picker({}))<CR>',
    { silent = true }
) -- Search project
map('n', '<leader>fs', ':Telescope lsp_document_symbols<CR>', { silent = true }) -- Search symbols
map('n', '<leader>fas', ':Telescope lsp_dynamic_workspace_symbols<CR>', { silent = true }) -- Search all project symbols
map('n', '<leader>fb', ':Telescope buffers<CR>', { silent = true }) -- Search buffers

-- Bufdelete
map('n', '<leader>bd', ':Bdelete ')
map('n', '<leader>bw', ':Bwipeout ')

-- Neoclip
map('', '<leader>p', ':Telescope neoclip<CR>')

-- Floaterm
map('n', '<leader>tn', ':FloatermNew<CR>')
map('n', '<leader>tk', ':FloatermKill<CR>')
map('n', '<leader>tt', ':FloatermToggle<CR>')
map('n', '<leader>[t', ':FloatermPrev<CR>')
map('n', '<leader>]t', ':FloatermNext<CR>')

-- Trouble
map('n', '<leader>xx', ':Trouble<CR>', silentnoremap)
map('n', '<leader>xl', ':Trouble loclist<CR>', silentnoremap)
map('n', '<leader>xq', ':Trouble quickfix<CR>', silentnoremap)

-- EasyMotion
cmd('map <leader><leader> <Plug>(easymotion-prefix)')

-- CamelCaseMotion
-- api.nvim_del_keymap('s', 'w')
-- api.nvim_del_keymap('s', 'b')
-- api.nvim_del_keymap('s', 'e')
-- api.nvim_del_keymap('s', 'ge')

cmd('map <silent> w <Plug>CamelCaseMotion_w')
cmd('map <silent> b <Plug>CamelCaseMotion_b')
cmd('map <silent> e <Plug>CamelCaseMotion_e')
cmd('map <silent> ge <Plug>CamelCaseMotion_ge')
cmd('sunmap w')
cmd('sunmap b')
cmd('sunmap e')
cmd('sunmap ge')
--map('', 'w', '<Plug>CamelCaseMotion_w')
--map('', 'b', '<Plug>CamelCaseMotion_b')
--map('', 'e', '<Plug>CamelCaseMotion_e')
--map('', 'ge', '<Plug>CamelCaseMotion_ge')

cmd('omap <silent> iw <Plug>CamelCaseMotion_iw')
cmd('xmap <silent> iw <Plug>CamelCaseMotion_iw')
cmd('omap <silent> ib <Plug>CamelCaseMotion_ib')
cmd('xmap <silent> ib <Plug>CamelCaseMotion_ib')
cmd('omap <silent> ie <Plug>CamelCaseMotion_ie')
cmd('xmap <silent> ie <Plug>CamelCaseMotion_ie')
--map('o', 'iw', '<Plug>CamelCaseMotion_iw')
--map('o', 'ib', '<Plug>CamelCaseMotion_ib')
--map('o', 'ie', '<Plug>CamelCaseMotion_ie')

--map('x', 'iw', '<Plug>CamelCaseMotion_iw')
--map('x', 'ib', '<Plug>CamelCaseMotion_ib')
--map('x', 'ie', '<Plug>CamelCaseMotion_ie')
