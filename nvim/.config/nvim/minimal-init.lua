-- Map <leader> to space
vim.keymap.set("n", "<Space>", "<Nop>")
-- Mapleader
vim.g.mapleader = " "

-- Relative line numbers (+ absolute current line number)
vim.opt.number = true
vim.opt.relativenumber = true

-- Map jk to leave ins mode
vim.keymap.set("i", "jk", "<Esc>")

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

-- Explorer
vim.keymap.set({ "n", "v" }, "<leader>e", "<CMD>Lexplore<CR>")
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 20
vim.g.netrw_liststyle = 3 -- Tree view
vim.g.netrw_localcopydircmd = "cp -r" -- Enable recursive directory copying
