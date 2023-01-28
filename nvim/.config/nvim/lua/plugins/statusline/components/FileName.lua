local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg

local filename_translations = {
    [""] = "[No Name]",
    ["neo-tree filesystem [1]"] = "NeoTree",
}

local special_filetype_filenames = {
    ["TelescopePrompt"] = "Telescope",
}

return {
    hl = {
        fg = get_hi_group_bg("BarAccent"),
        bg = get_hi_group_bg("BarHighlight"),
    },

    provider = function()
        local filename = vim.fn.expand("%:t")
        local filetype = vim.bo.filetype
        return special_filetype_filenames[filetype]
            or filename_translations[filename]
            or filename
    end,
}
