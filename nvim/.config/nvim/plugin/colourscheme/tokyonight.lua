local function common_cfg()
    vim.pack.add({
        { src = "https://github.com/folke/tokyonight.nvim" },
    })

    require("tokyonight").setup({
        on_highlights = function(hl, c)
            local prompt = c.bg_dark
            hl.TelescopeNormal = {
                bg = c.bg_dark,
                fg = c.fg_dark,
            }
            hl.TelescopeBorder = {
                bg = c.bg_dark,
                fg = c.bg_dark,
            }
            hl.TelescopePromptNormal = {
                bg = prompt,
            }
            hl.TelescopePromptBorder = {
                bg = prompt,
                fg = prompt,
            }
            hl.TelescopePromptTitle = {
                bg = prompt,
                fg = prompt,
            }
            hl.TelescopePreviewTitle = {
                bg = c.bg_dark,
                fg = c.bg_dark,
            }
            hl.TelescopeResultsTitle = {
                bg = c.bg_dark,
                fg = c.bg_dark,
            }
        end,
    })
end

if vim.g.colourscheme == "Tokyo Night Storm" then
    common_cfg()
    vim.cmd.colorscheme("tokyonight-storm")
elseif vim.g.colourscheme == "Tokyo Night Moon" then
    common_cfg()
    vim.cmd.colorscheme("tokyonight-moon")
end
