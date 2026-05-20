vim.keymap.set("n", "<LEADER>ff", function()
    require("fff").find_files()
end)

vim.keymap.set("n", "<LEADER>fg", function()
    require("fff").live_grep()
end)

vim.keymap.set("v", "<LEADER>fg", function()
    local selection = require("h").get_visual_selection()
    require("fff").live_grep({ query = selection })
end)

vim.keymap.set("n", "<LEADER>fc", function()
    require("fff").find_files({ query = "git:modified " })
end)
