local colourscheme_common = require("ui.colourscheme_common")

local themes = {}
local M = {}

function M.register(theme)
    table.insert(themes, theme)
end

function M.apply()
    local ok, err = pcall(colourscheme_common)
    if not ok then
        vim.notify(
            "Colourscheme common highlights failed: " .. tostring(err),
            vim.log.levels.WARN,
            { title = "Theme" }
        )
    end

    for _, theme in ipairs(themes) do
        local theme_ok, theme_err = pcall(theme)
        if not theme_ok then
            vim.notify(
                "Plugin theme failed: " .. tostring(theme_err),
                vim.log.levels.WARN,
                { title = "Theme" }
            )
        end
    end
end

vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("ui_theme", { clear = true }),
    callback = M.apply,
})

-- Plugin theme modules are loaded after the startup colourscheme, so apply
-- everything once more after all plugin files have registered their themes.
vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        vim.schedule(M.apply)
    end,
})

return M
