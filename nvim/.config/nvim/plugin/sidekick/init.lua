-- vim.pack.add({
--     { src = "<plugin-dependency>" },
-- })

vim.pack.add({
    { src = "https://github.com/folke/sidekick.nvim" },
})

require("sidekick").setup({
    nes = {
        enabled = false,
    },
    cli = {
        tools = {
            aider_cheap = {
                cmd = { "aider", "--model", "deepseek/deepseek-chat" },
            },
            aider_arch = {
                cmd = {
                    "aider",
                    "--architect",
                    "--model",
                    "deepseek/deepseek-reasoner",
                    "--editor-model",
                    "deepseek/deepseek-chat",
                },
            },
            aider_gemini = {
                cmd = { "aider", "--model", "gemini/gemini-2.5-pro" },
            },
        },
    },
})

vim.keymap.set("n", "<C-f>", ":Sidekick nes apply")
