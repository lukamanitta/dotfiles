local wezterm = require("wezterm")

local U = {}

U.jetbrains = {
    {
        intensity = "Bold",
        font = wezterm.font(
            "JetBrains Mono",
            { weight = "ExtraBold" }
        ),
    },
    {
        intensity = "Bold",
        italic = true,
        font = wezterm.font(
            "JetBrains Mono",
            { weight = "ExtraBold" }
        ),
    },
    {
        intensity = "Half",
        font = wezterm.font(
            "JetBrains Mono",
            { weight = "Light" }
        ),
    },
    {
        intensity = "Half",
        italic = true,
        font = wezterm.font(
            "JetBrains Mono Light Italic"
        ),
    },
}

U.firacode = {
    {
        intensity = "Half",
        font = wezterm.font(
            "Fira Code",
            { weight = "Light" }
        ),
    },
}

U.commitmono= {
    {
        intensity = "Bold",
        italic = true,
        font = wezterm.font(
            "CommitMono Nerd Font Bold Italic"
        ),
    },
}

U.ibmplexmono = {
    {
        intensity = "Bold",
        font = wezterm.font(
            "IBM Plex Mono",
            { weight = "Bold" }
        ),
    },
    {
        intensity = "Bold",
        italic = true,
        font = wezterm.font(
            "IBM Plex Mono",
            { weight = "Bold" }
        ),
    },
    {
        intensity = "Half",
        font = wezterm.font(
            "IBM Plex Mono",
            { weight = "Light" }
        ),
    },
    {
        intensity = "Half",
        italic = true,
        font = wezterm.font(
            "IBM Plex Mono",
            { weight = "Light" }
        ),
    },
}

return U
