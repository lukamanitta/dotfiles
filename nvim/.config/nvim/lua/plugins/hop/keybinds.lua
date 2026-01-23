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
vim.keymap.set("n", "<LEADER>w", ":HopWord<CR>", { silent = true })
