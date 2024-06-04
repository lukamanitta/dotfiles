-- TODO: wip. Buffer elements seem to share a bufnr?

local utils = require("heirline.utils")

local components = require("plugins.ui.heirline.components")
local props = require("plugins.ui.heirline.props")
local get_hl = require("helpers").get_hl

local ColouredBufferIcon =
require("plugins.ui.heirline.components.ColouredBufferIcon")

local filename_translations = {
    [""] = "[No Name]",
    ["neo-tree filesystem [1]"] = "NeoTree",
}

local special_filetype_filenames = {
    ["TelescopePrompt"] = "Telescope",
}

local BufferLineFileName =  {
    provider = function(self)
        -- local filename = vim.fn.expand("%:t")
        local filename = self.filename
        filename = vim.fn.expand("%:t")
        local filetype = vim.bo.filetype
        local display_name = special_filetype_filenames[filetype]
            or filename_translations[filename]
            or filename
        return display_name .. " "
    end,

    hl = function(self)
        return { bold = self.is_active or self.is_visible }
    end
}

local BufferLineFileNameBlock = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(self.bufnr)
    end,
    hl = function(self)
        if self.is_active then
            return "BarHighlight2"
        else
            return "StatusLine"
        end
    end,
    BufferLineFileName
}

return utils.make_buflist(
    BufferLineFileNameBlock,
    { provider = "", hl = { fg = get_hl("StatusLine", "bg#") } },
    { provider = "", hl = { fg = get_hl("StatusLine", "bg#") } }
)
