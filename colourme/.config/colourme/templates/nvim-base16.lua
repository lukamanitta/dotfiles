local palette

if vim.o.background == "dark" then
    palette = {
        base00 = "#{{hex: base00}}",
        base01 = "#{{hex: base01}}",
        base02 = "#{{hex: base02}}",
        base03 = "#{{hex: base03}}",
        base04 = "#{{hex: base04}}",
        base05 = "#{{hex: base05}}",
        base06 = "#{{hex: base06}}",
        base07 = "#{{hex: base07}}",
        base08 = "#{{hex: base08}}",
        base09 = "#{{hex: base09}}",
        base0A = "#{{hex: base0A}}",
        base0B = "#{{hex: base0B}}",
        base0C = "#{{hex: base0C}}",
        base0D = "#{{hex: base0D}}",
        base0E = "#{{hex: base0E}}",
        base0F = "#{{hex: base0F}}",
    }
end

if vim.o.background == "light" then
    palette = {
        base00 = "#{{hex: base00}}",
        base01 = "#{{hex: base01}}",
        base02 = "#{{hex: base02}}",
        base03 = "#{{hex: base03}}",
        base04 = "#{{hex: base04}}",
        base05 = "#{{hex: base05}}",
        base06 = "#{{hex: base06}}",
        base07 = "#{{hex: base07}}",
        base08 = "#{{hex: base08}}",
        base09 = "#{{hex: base09}}",
        base0A = "#{{hex: base0A}}",
        base0B = "#{{hex: base0B}}",
        base0C = "#{{hex: base0C}}",
        base0D = "#{{hex: base0D}}",
        base0E = "#{{hex: base0E}}",
        base0F = "#{{hex: base0F}}",
    }
end

return palette
