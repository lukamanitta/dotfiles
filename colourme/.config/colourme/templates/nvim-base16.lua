local palette

if vim.o.background == "dark" then
    palette = {
        base00 = "#{{hex: regular.black}}",
        base01 = "#{{hex: regular.red}}",
        base02 = "#{{hex: regular.green}}",
        base03 = "#{{hex: regular.yellow}}",
        base04 = "#{{hex: regular.blue}}",
        base05 = "#{{hex: regular.magenta}}",
        base06 = "#{{hex: regular.cyan}}",
        base07 = "#{{hex: regular.white}}",
        base08 = "#{{hex: bright.black}}",
        base09 = "#{{hex: bright.red}}",
        base0A = "#{{hex: bright.green}}",
        base0B = "#{{hex: bright.yellow}}",
        base0C = "#{{hex: bright.blue}}",
        base0D = "#{{hex: bright.magenta}}",
        base0E = "#{{hex: bright.cyan}}",
        base0F = "#{{hex: bright.white}}",
    }
end

if vim.o.background == "light" then
    palette = {
        base00 = "#{{hex: regular.black}}",
        base01 = "#{{hex: regular.red}}",
        base02 = "#{{hex: regular.green}}",
        base03 = "#{{hex: regular.yellow}}",
        base04 = "#{{hex: regular.blue}}",
        base05 = "#{{hex: regular.magenta}}",
        base06 = "#{{hex: regular.cyan}}",
        base07 = "#{{hex: regular.white}}",
        base08 = "#{{hex: bright.black}}",
        base09 = "#{{hex: bright.red}}",
        base0A = "#{{hex: bright.green}}",
        base0B = "#{{hex: bright.yellow}}",
        base0C = "#{{hex: bright.blue}}",
        base0D = "#{{hex: bright.magenta}}",
        base0E = "#{{hex: bright.cyan}}",
        base0F = "#{{hex: bright.white}}",
    }
end

return palette
