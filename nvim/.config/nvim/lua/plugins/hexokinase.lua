local apply_globals = require("utils.config").apply_globals
local general_icons = require("assets.icons").general

apply_globals({
    Hexokinase_highlighters = { "virtual" },
    Hexokinase_virtualText = general_icons.Circle,
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
