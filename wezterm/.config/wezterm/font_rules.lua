local wezterm = require("wezterm")

local U = {
    {
        intensity = "Bold",
        font = wezterm.font(
            "JetBrainsMono Nerd Font",
            { weight = "ExtraBold" }
        ),
    },
    {
        intensity = "Bold",
        italic = true,
        font = wezterm.font(
            "JetBrainsMono Nerd Font",
            { weight = "ExtraBold" }
        ),
    },
    {
        intensity = "Half",
        font = wezterm.font(
            "JetBrainsMono Nerd Font",
            { weight = "Light" }
        ),
    },
    -- {
    --     intensity = "Half",
    --     italic = true,
    --     font = wezterm.font(
    --         "JetBrainsMono Light Italic Nerd Font",
    --         { weight = "LightItalic" }
    --     ),
    -- },
}

return U
