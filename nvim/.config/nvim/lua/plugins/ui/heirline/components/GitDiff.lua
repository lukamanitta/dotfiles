local conditions = require("heirline.conditions")
local get_hl = require("helpers").get_hl
local git_icons = require("icons").git

return {
    condition = conditions.is_git_repo,

    init = function(self)
        ---@diagnostic disable-next-line: undefined-field
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0
            or self.status_dict.removed ~= 0
            or self.status_dict.changed ~= 0
    end,

    hl = { fg = "orange", bg = get_hl("StatusLine", "bg#") },

    {
        provider = " ",
    },

    {
        provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and (git_icons.Added .. " " .. count .. " ")
        end,
        hl = { fg = get_hl("GitSignsAdd", "fg#") },
    },

    {
        provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and (git_icons.Removed .. " " .. count .. " ")
        end,
        hl = { fg = get_hl("GitSignsDelete", "fg#") },
    },

    {
        provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and (git_icons.Modified .. " " .. count .. " ")
        end,
        hl = { fg = get_hl("GitSignsChange", "fg#") },
    },
}
