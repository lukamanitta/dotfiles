-- <leader> = <space>
vim.keymap.set("n", "<SPACE>", "<NOP>")
vim.g.mapleader = "<SPACE>"

-- "jk" to leave ins mode
vim.keymap.set("i", "jk", "<ESC>")

-- Switch to alternate file
vim.keymap.set("n", "<LEADER>a", "<C-^>")

-- <leader> + direction for window navigation
vim.keymap.set({ "n", "v" }, "<leader>h", ":wincmd h<CR>")
vim.keymap.set({ "n", "v" }, "<leader>j", ":wincmd j<CR>")
vim.keymap.set({ "n", "v" }, "<leader>k", ":wincmd k<CR>")
vim.keymap.set({ "n", "v" }, "<leader>l", ":wincmd l<CR>")

-- Make capital Y yanking work consistently with other capital letters
vim.keymap.set("n", "Y", "y$")

-- Clear search highlight
vim.keymap.set("n", "//", ":nohlsearch<CR>")
