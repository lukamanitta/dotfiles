-- https://www.reddit.com/r/neovim/comments/1pndf9e/my_new_nvimtreesitter_configuration_for_the_main/

require("nvim-treesitter").setup({})

require("nvim-treesitter")
    .install({
        "lua",
        "rust",
        "ruby",
        "python",

        "bash",

        "tsx",
        "svelte",

        "javascript",
        "typescript",

        "html",
        "css",
        "scss",

        "json",
        "yaml",
        "toml",

        "markdown",
        "markdown_inline",
    })
    :wait(300000) -- wait up to 5 minutes for installation to complete

require("nvim-treesitter").update():wait(300000) -- wait up to 5 minutes for update to complete

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local treesitter = require("nvim-treesitter")
        local lang = vim.treesitter.language.get_lang(args.match)
        if vim.list_contains(treesitter.get_installed(), lang) then
            vim.treesitter.start(args.buf)
        end
    end,
    desc = "Enable nvim-treesitter for supported filetypes",
})
