local function common_cfg()
    vim.pack.add({
        { src = "https://github.com/rose-pine/neovim" },
    })

    require("rose-pine").setup()
end

if vim.g.colourscheme == "Rose Pine" then
    common_cfg()
    vim.cmd.colorscheme("rose-pine")
    require("ui.colourscheme_common")()
elseif vim.g.colourscheme == "Rose Pine Moon" then
    common_cfg()
    vim.cmd.colorscheme("rose-pine-moon")
    require("ui.colourscheme_common")()
elseif vim.g.colourscheme == "Rose Pine Dawn" then
    common_cfg()
    vim.cmd.colorscheme("rose-pine-dawn")
    require("ui.colourscheme_common")()
end
