-- Map <leader> to space
vim.keymap.set("n", "<Space>", "<Nop>")
-- Mapleader
vim.g.mapleader = " "

-- Map jk to leave ins mode
vim.keymap.set("i", "jk", "<Esc>")

-- map('', ';', ':', silentnoremap)
-- cmd("map ; :") -- cmdline is hidden until another key is pressed unless this is done in viml
vim.keymap.set("n", ";", ":")

vim.keymap.set("n", "-", "^")

-- Switch to alternate file
vim.keymap.set("n", "<leader>a", "<C-^>")

-- <leader> + direction for window navigation
vim.keymap.set({ "n", "v" }, "<leader>h", "<CMD>wincmd h<CR>")
vim.keymap.set({ "n", "v" }, "<leader>j", "<CMD>wincmd j<CR>")
vim.keymap.set({ "n", "v" }, "<leader>k", "<CMD>wincmd k<CR>")
vim.keymap.set({ "n", "v" }, "<leader>l", "<CMD>wincmd l<CR>")

-- Make capital Y yanking work consistently with other capital letters
vim.keymap.set("n", "Y", "y$")

-- Keep cursor centered when cycling through search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Clear search highlight
vim.keymap.set("n", "//", "<CMD>nohlsearch<CR>")
