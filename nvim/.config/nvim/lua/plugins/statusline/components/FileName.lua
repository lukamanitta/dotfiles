local ColouredBufferIcon =
require("plugins.statusline.components.ColouredBufferIcon")

local filename_translations = {
    [""] = "[No Name]",
    ["neo-tree filesystem [1]"] = "NeoTree",
}

local special_filetype_filenames = {
    ["TelescopePrompt"] = "Telescope",
}

return {
    ColouredBufferIcon(0),

    {
        provider = function()
            local filename = vim.fn.expand("%:t")
            local filetype = vim.bo.filetype
            local display_name = special_filetype_filenames[filetype]
                or filename_translations[filename]
                or filename
            return " " .. display_name .. " "
        end,
    },
}
