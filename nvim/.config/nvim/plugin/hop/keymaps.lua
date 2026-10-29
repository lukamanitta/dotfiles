local function hint_char(direction, opts)
    opts = vim.tbl_extend("force", {
        direction = direction,
        current_line_only = true,
    }, opts or {})

    return require("hop").hint_char1(opts)
end

local after_cursor = require("hop.hint").HintDirection.AFTER_CURSOR
local before_cursor = require("hop.hint").HintDirection.BEFORE_CURSOR

vim.keymap.set("n", "f", function()
    return hint_char(after_cursor)
end, { desc = "Hop to character after cursor" })

vim.keymap.set("n", "F", function()
    return hint_char(before_cursor)
end, { desc = "Hop to character before cursor" })

vim.keymap.set("o", "f", function()
    return hint_char(after_cursor, { inclusive_jump = true })
end, { desc = "Hop to character after cursor (inclusive)" })

vim.keymap.set("o", "F", function()
    return hint_char(before_cursor, { inclusive_jump = true })
end, { desc = "Hop to character before cursor (inclusive)" })

vim.keymap.set("", "t", function()
    return hint_char(after_cursor, { hint_offset = -1 })
end, { desc = "Hop to character after cursor (till)" })

vim.keymap.set("", "T", function()
    return hint_char(before_cursor, { hint_offset = -1 })
end, { desc = "Hop to character before cursor (till)" })

vim.keymap.set("n", "<LEADER>w", ":HopWord<CR>", {
    silent = true,
    desc = "Hop to word",
})
