require("hologram").setup({
    auto_display = true,
})

local buf_images = {}

--- Adds a new image to the specified buffer's image table
---@param img Image
local add_image_to_buf = function(bufnr, img, display, opts)
    img.opts = opts
    local buf = bufnr or vim.api.nvim_get_current_buf()
    if buf_images[buf] == nil then
        buf_images[buf] = {}
    end
    table.insert(buf_images[buf], img)
    if display then
        img:display(img.opts.row, img.opts.col, buf, img.opts)
    end
end

local display_buf_images = function(bufnr)
    local buf = bufnr or vim.api.nvim_get_current_buf()
    if buf_images[buf] == nil then
        return
    end
    for _, img in ipairs(buf_images[buf]) do
        img:display(img.opts.row, img.opts.col, buf, img.opts)
    end
end

local undisplay_buf_images = function(bufnr)
    local buf = bufnr or vim.api.nvim_get_current_buf()
    if buf_images[buf] == nil then
        return
    end
    for _, img in ipairs(buf_images[buf]) do
        img:delete(buf, { free = false })
    end
end

return add_image_to_buf
