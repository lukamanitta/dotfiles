-- globals AND options here
-- TODO: Maybe use a util to provide a list? like old config

-- Recognise _ as word separator
vim.cmd("set iskeyword-=_") -- TODO: write this in lua

-- Global statusline
vim.opt.fillchars:append({
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┫",
    vertright = "┣",
    verthoriz = "╋",
    eob = "", -- TODO: Themed maybe, use icon assets
})
