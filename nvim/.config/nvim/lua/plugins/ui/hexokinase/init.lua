require("helpers").set_scope_opts(vim.g, {
    Hexokinase_ftDisabled = { "markdown" },
    Hexokinase_highlighters = { "virtual" },
    Hexokinase_virtualText = require("icons").general.Circle,
    Hexokinase_optInPatterns = {
        "full_hex", -- #FFFFFF
        "triple_hex", -- #FFF
        "rgb", -- rgb(255,255,255)
        "rgba", -- rgba(255,255,255,1)
        "hsl", -- hsl(255, 100%, 100%)
        "hsla", -- hsla(255, 100%, 100%, 1)
        "colour_names", -- white
    },
})

-- require("plugins.ui.hexokinase.custom_hl")
-- require("plugins.ui.hexokinase.keybinds")
