require("h").overwrite_keys(vim.g, {

    -- My variables
})

require("h").overwrite_keys(vim.o, {
    syntax = "off",
    hidden = true, -- Switch away from unsaved buffers
    number = true,
    relativenumber = true,
    scrolloff = 10,
    sidescrolloff = 5,
    mouse = "a",
    signcolumn = "yes",
    updatetime = 50,
    equalalways = false,
    splitbelow = true,
    termguicolors = true,
    cursorline = true,
    laststatus = 3,
    incsearch = true,
    inccommand = "nosplit",
    belloff = "all", -- Shut that f**king bell sound off >:(
    foldmethod = "indent",
    foldlevel = 99,
    spelllang = "en_au,en_us",
    spelloptions = "camel,noplainbuffer",
    splitkeep = "screen",
    completeopt = "fuzzy,menu,menuone,noinsert,popup",
})

-- Recognise _ as a word separator
vim.opt.iskeyword:remove("_")

vim.fn.matchadd("ColorColumn", "\\%80v", 100) -- DANGER ZONE FUCK NOT 80 CHARAC

-- Window separators to accomodate global statusline (laststatus=3)
vim.opt.fillchars:append({
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┫",
    vertright = "┣",
    verthoriz = "╋",
    eob = " ",
})
