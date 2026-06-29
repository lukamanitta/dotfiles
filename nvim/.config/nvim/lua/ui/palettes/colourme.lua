local palette

if vim.o.background == "dark" then
    palette = {
        base00 = "#222436",
        base01 = "#1e2030",
        base02 = "#2f334d",
        base03 = "#444a73",
        base04 = "#828bb8",
        base05 = "#c8d3f5",
        base06 = "#b4c2f0",
        base07 = "#c8d3f5",
        base08 = "#c099ff",
        base09 = "#ffc777",
        base0A = "#ffc777",
        base0B = "#c3e88d",
        base0C = "#86e1fc",
        base0D = "#82aaff",
        base0E = "#fca7ea",
        base0F = "#c53b53",
    }
end

if vim.o.background == "light" then
    palette = {
        base00 = "#222436",
        base01 = "#1e2030",
        base02 = "#2f334d",
        base03 = "#444a73",
        base04 = "#828bb8",
        base05 = "#c8d3f5",
        base06 = "#b4c2f0",
        base07 = "#c8d3f5",
        base08 = "#c099ff",
        base09 = "#ffc777",
        base0A = "#ffc777",
        base0B = "#c3e88d",
        base0C = "#86e1fc",
        base0D = "#82aaff",
        base0E = "#fca7ea",
        base0F = "#c53b53",
    }
end

return palette
