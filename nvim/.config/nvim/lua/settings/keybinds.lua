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
-- Leave ins mode in terminal because unmapping doesn't fucking work for fucking lazygit
-- map('t', '<Esc>', '<C-\\><C-n>')

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

-- Open NvimTree
map('n', '<leader>e', ':NvimTreeToggle<CR>')

-- Github Copilot
cmd('imap <silent><script><expr> <C-J> copilot#Accept("")')
cmd('let g:copilot_no_tab_map = v:true')

-- Lazygit
map('n', '<leader>git', ':LazyGit<CR>')

-- Hop.nvim
map(
    'n',
    'f',
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>"
)
map(
    'n',
    'F',
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>"
)
map(
    'o',
    'f',
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>"
)
map(
    'o',
    'F',
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>"
)
map(
    '',
    't',
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>"
)
map(
    '',
    'T',
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>"
)
map('n', '<leader>w', ':HopWord<CR>', { silent = true })

-- Bufferline
--
map('n', '<leader>bj', ':BufferLinePick<CR>')

-- TODO: Make this prettier
-- Telescope
map(
    'n',
    '<leader>ff',
    ':lua require("plugins.telescope.tele_utils").smart_file_finder(require("plugins.telescope.tele_utils").responsive_layout({}))<CR>',
    { silent = true }
)
map(
    'n',
    '<leader>fg',
    ':lua require("telescope.builtin").live_grep(require("plugins.telescope.tele_utils").responsive_layout({}))<CR>',
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
