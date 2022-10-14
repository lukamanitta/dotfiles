local apply_options = require("utils.config").apply_options

apply_options({
    syntax = "off",
    hidden = true,
    number = true,
    relativenumber = true,
    cmdheight = 1,
    mouse = "a",
    signcolumn = "yes",
    updatetime = 50,
    noequalalways = true,
    splitbelow = true,
    lazyredraw = false,
    ttyfast = true,
    termguicolors = true,
    cursorline = true,
    laststatus = 3,
    incsearch = true,
    inccommand = "nosplit",
    encoding = "utf-8",
    expandtab = true, -- Expand tabs to spaces
    shiftwidth = 4, -- Tab = 4 spaces
    backspace = "indent,eol,start",
    belloff = "all", -- Shut that fucking bell sound off
    foldmethod = "indent",
    foldnestmax = 10,
    nofoldenable = true,
    foldlevel = 1,
    scrolloff = 8,
    sidescrolloff = 5,
    spell = false,
    spelllang = "en_au,en_us",
    spelloptions = "camel,noplainbuffer",
    splitkeep = "screen",
})

vim.cmd("set iskeyword-=_") -- Recognise _ as word separator
vim.fn.matchadd("ColorColumn", "\\%80v", 100) -- DANGER XONE FUCK NOT 80 CHARAC

-- For global statusline
vim.opt.fillchars:append({
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┨",
    vertright = "┣",
    verthoriz = "╋",
})
