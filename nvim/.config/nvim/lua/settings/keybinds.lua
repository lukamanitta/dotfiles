-- <LEADER> = <space>
vim.g.mapleader = " "
vim.keymap.set("n", "<SPACE>", "<NOP>", { desc = "Disable default space" })

-- "jk" to leave insert mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Switch to alternate file
vim.keymap.set("n", "<LEADER>a", "<C-^>", { desc = "Switch to alternate file" })

-- <LEADER> + direction for window navigation
vim.keymap.set({ "n", "v" }, "<LEADER>h", ":wincmd h<CR>", {
    desc = "Window left",
})
vim.keymap.set({ "n", "v" }, "<LEADER>j", ":wincmd j<CR>", {
    desc = "Window down",
})
vim.keymap.set({ "n", "v" }, "<LEADER>k", ":wincmd k<CR>", {
    desc = "Window up",
})
vim.keymap.set({ "n", "v" }, "<LEADER>l", ":wincmd l<CR>", {
    desc = "Window right",
})

-- Make capital Y yanking work consistently with other capital letters
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })

-- Clear search highlight
vim.keymap.set("n", "//", ":nohlsearch<CR>", {
    desc = "Clear search highlight",
})

if vim.fn.executable("lazygit") == 1 then
    vim.keymap.set("n", "<LEADER>git", ":terminal lazygit<CR>", {
        desc = "Open lazygit",
    })
end
