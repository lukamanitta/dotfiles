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

-- todo-comments
vim.keymap.set("n", "<leader>todo", "<CMD>TodoTrouble<CR>")
vim.keymap.set("n", "<leader>ftodo", "<CMD>TodoTelescope<CR>")

-- Lazygit
vim.keymap.set("n", "<leader>git", "<CMD>LazyGit<CR>")

-- zk
local zkcmds = require("zk.commands")
vim.keymap.set("n", "<leader>zkcd", "<CMD>ZkCd<CR>")
vim.keymap.set("n", "<leader>zkn", function()
    return vim.ui.input(
        { prompt = "New Note Title: ", kind = "center" },
        function(title)
            if title then
                vim.ui.input({
                    prompt = "New Note Directory (blank for root): ",
                    kind = "center",
                    completion = "dir", -- This needs to be customlist relative to $NOTE_DIR
                }, function(dir)
                    zkcmds.get("ZkNew")({ title = title, dir = dir })
                end)
            end
        end
    )
end)
vim.keymap.set("v", "<leader>zkn", function()
    return vim.ui.input(
        { prompt = "New Note Title: ", kind = "center" },
        function(input)
            if input then
                zkcmds.get("ZkNewFromContentSelection")({ title = input })
            end
        end
    )
end)
vim.keymap.set("n", "<leader>fzkn", "<CMD>ZkNotes<CR>")
vim.keymap.set("n", "<leader>fzkt", "<CMD>ZkTags<CR>")

-- Hop.nvim
vim.keymap.set("n", "f", function()
    return require("hop").hint_char1({
        direction = require("hop.hint").HintDirection.AFTER_CURSOR,
        current_line_only = true,
    })
end)
vim.keymap.set("n", "F", function()
    return require("hop").hint_char1({
        direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
        current_line_only = true,
    })
end)
vim.keymap.set("o", "f", function()
    return require("hop").hint_char1({
        direction = require("hop.hint").HintDirection.AFTER_CURSOR,
        current_line_only = true,
        inclusive_jump = true,
    })
end)
vim.keymap.set("o", "F", function()
    return require("hop").hint_char1({
        direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
        current_line_only = true,
        inclusive_jump = true,
    })
end)
vim.keymap.set("", "t", function()
    return require("hop").hint_char1({
        direction = require("hop.hint").HintDirection.AFTER_CURSOR,
        current_line_only = true,
        hint_offset = -1,
    })
end)
vim.keymap.set("", "T", function()
    return require("hop").hint_char1({
        direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
        current_line_only = true,
        hint_offset = -1,
    })
end)
vim.keymap.set("n", "<leader>w", "<CMD>HopWord<CR>", { silent = true })

-- TODO: Make this prettier
-- Telescope
vim.keymap.set("n", "<leader>ff", function()
    return require("plugins.telescope.tele_utils").smart_file_finder(
        require("plugins.telescope.tele_utils").responsive_layout({})
    )
end, { silent = true })
vim.keymap.set("n", "<leader>fc", function()
    return require("telescope.builtin").git_status(
        require("plugins.telescope.tele_utils").responsive_layout({})
    )
end, { silent = true }) -- Search project
vim.keymap.set("n", "<leader>fg", function()
    return require("telescope.builtin").live_grep(
        require("plugins.telescope.tele_utils").responsive_layout({})
    )
end, { silent = true }) -- Search project
vim.keymap.set("n", "<leader>fs", "<CMD>Telescope lsp_document_symbols<CR>", {
    silent = true,
}) -- Search symbols
vim.keymap.set(
    "n",
    "<leader>fas",
    "<CMD>Telescope lsp_dynamic_workspace_symbols<CR>",
    { silent = true }
) -- Search all project symbols
vim.keymap.set(
    "n",
    "<leader>fb",
    "<CMD>Telescope buffers<CR>",
    { silent = true }
) -- Search buffers
vim.keymap.set("n", "<leader>fr", function()
    return require("telescope.builtin").resume(
        require("plugins.telescope.tele_utils").responsive_layout({})
    )
end)
vim.keymap.set("n", "<leader>fm", function()
    return require("plugins.telescope.tele_utils").git_modified_finder(
        require("plugins.telescope.tele_utils").responsive_layout({})
    )
end)
vim.keymap.set("n", "z=", "<CMD>Telescope spell_suggest<CR>")

-- Neoclip
vim.keymap.set("", "<leader>p", "<CMD>Telescope neoclip<CR>")

-- Floaterm
vim.keymap.set("n", "<leader>tn", "<CMD>FloatermNew<CR>")
vim.keymap.set("n", "<leader>tk", "<CMD>FloatermKill<CR>")
vim.keymap.set("n", "<leader>tt", "<CMD>FloatermToggle<CR>")
vim.keymap.set("n", "<leader>[t", "<CMD>FloatermPrev<CR>")
vim.keymap.set("n", "<leader>]t", "<CMD>FloatermNext<CR>")

-- Trouble
vim.keymap.set("n", "<leader>xx", "<CMD>Trouble<CR>")
vim.keymap.set("n", "<leader>xl", "<CMD>Trouble loclist<CR>")
vim.keymap.set("n", "<leader>xq", "<CMD>Trouble quickfix<CR>")
