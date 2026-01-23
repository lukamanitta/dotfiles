local web_devicons_ok, web_devicons = pcall(require, "nvim-web-devicons")
if web_devicons_ok then
    local material_icon_ok, material_icon = pcall(require, "nvim-material-icon")
    if not material_icon_ok then
        return
end

web_devicons.setup({
    override = material_icon.get_icons(),
})
end


require("nvim-material-icon").setup({
    -- your personnal icons can go here (to override)
    -- you can specify color or cterm_color instead of specifying both of them
    -- DevIcon will be appended to `name`
    override = {
        zsh = {
            icon = "",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh",
        },
    },
    -- globally enable different highlight colors per icon (default to true)
    -- if set to false all icons will have the default icon's color
    color_icons = true,
    -- globally enable default icons (default to false)
    -- will get overriden by `get_icons` option
    default = true,
})
