-- TODO: move keybinds to respective plugin files
-- local api = vim.api

-- Port to vim.keymap.set

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

-- Open Neotree
-- :Neotree ACTION SOURCE POSITION TOGGLE DIR REVEAL REVEAL_FILE REVEAL_FORCE_CWD
vim.keymap.set(
    "n",
    "<leader>e",
    "<CMD>Neotree focus filesystem float toggle reveal<CR>"
)
vim.keymap.set(
    "n",
    "<leader>b",
    "<CMD>Neotree focus buffers float toggle reveal<CR>"
)

-- Github Copilot
vim.cmd('imap <silent><script><expr> <C-\\> copilot#Accept("<CR>")')
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true

-- Lazygit
vim.keymap.set("n", "<leader>git", "<CMD>LazyGit<CR>")

-- TODO: Make this prettier
-- Telescope
vim.keymap.set("n", "<leader>ff", function()
    return require("plugins.telescope.tele_utils").smart_file_finder()
end, { silent = true })

vim.keymap.set("n", "<leader>fc", function()
    return require("telescope.builtin").git_status()
end, { silent = true }) -- Search project

vim.keymap.set("n", "<leader>fg", function()
    return require("telescope.builtin").live_grep()
end, { silent = true }) -- Search project

vim.keymap.set("n", "<leader>fs", "<CMD>Telescope lsp_document_symbols<CR>", {
    silent = true,
}) -- Search symbols

vim.keymap.set("n", "<leader>fas", function()
    return require("telescope.builtin").lsp_workspace_symbols()
end, { silent = true }) -- Search all project symbols

vim.keymap.set("n", "<leader>fb", function()
    require("telescope.builtin").buffers()
end, { silent = true }) -- Search buffers

vim.keymap.set("n", "<leader>fr", function()
    return require("telescope.builtin").resume()
end)

vim.keymap.set("n", "<leader>fm", function()
    return require("plugins.telescope.tele_utils").git_modified_finder()
end)

vim.keymap.set("n", "z=", function()
    return require("telescope.builtin").spell_suggest({
        prompt_title = false,
        layout_config = {
            height = 15,
        },
    })
end)
