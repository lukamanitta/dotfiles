local conditions = require("heirline.conditions")
local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
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

    hl = { fg = "orange", bg = get_hi_group_bg("StatusLine") },

    {
        provider = " ",
    },

    {
        provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and (git_icons.Added .. " " .. count .. " ")
        end,
        hl = { fg = get_hi_group_fg("GitSignsAdd") },
    },

    {
        provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and (git_icons.Removed .. " " .. count .. " ")
        end,
        hl = { fg = get_hi_group_fg("GitSignsDelete") },
    },

    {
        provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and (git_icons.Modified .. count)
        end,
        hl = { fg = get_hi_group_fg("GitSignsChange") },
    },
}
