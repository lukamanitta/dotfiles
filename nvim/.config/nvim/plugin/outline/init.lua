vim.pack.add({
    {
        src = "https://github.com/hedyhli/outline.nvim",
    },
})

local function transformed_blink_cmp_kinds()
    local blink_cmp_kinds =
        require("blink.cmp.config.appearance").default.kind_icons
    local transformed_kinds = {}
    for key, value in pairs(blink_cmp_kinds) do
        transformed_kinds[key] = {
            icon = value,
            hl = "CmpItemKind" .. key,
        }
    end
    return transformed_kinds
end

require("outline").setup({
    outline_window = {
        position = "right",
        width = 20,
        winhl = "Normal:Normal",
    },
    preview_window = {
        auto_preview = false,
    },
    symbols = {
        filter = {
            default = { "String", "Variable", exclude = true },
        },
        icons = transformed_blink_cmp_kinds(),
    },
})
