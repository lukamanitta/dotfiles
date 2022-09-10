-- Requires `pngpaste` for MacOS

local add_image_to_buf = require("plugins.markdown.images.hologram")
require("clipboard-image").setup({
    markdown = {
        img_dir = "images",
        img_dir_txt = "images",
        affix = "![](%s)",
        img_name = function()
            local name = vim.fn.input("Image name: ")
            return os.date("%Y%m%d-") .. name
        end,
        img_handler = function(img)
            -- Hologram display image at cursor position (use img.path)
            local buf = vim.api.nvim_get_current_buf()
            local line = vim.api.nvim_win_get_cursor(0)[1]
            local hologram_img = require("hologram.image"):new(img.path, {
                format = 100, -- .png format
                transmission_type = "f", -- file transmission
            })
            add_image_to_buf(buf, hologram_img, true, {
                row = vim.api.nvim_win_get_cursor(0)[1],
                col = 0,
                buf = vim.api.nvim_get_current_buf(),
                rows = 10,
            })
        end,
    },
})
