require("helpers").set_scope_opts(vim.g, {
    scrolloff = 10,
    sidescrolloff = 5,
    omni_sql_default_compl_type = "syntax",

    -- My variables
    icon_style = "solid" -- "solid" | "outline" | "text"
})

require("helpers").set_scope_opts(vim.o, {
    syntax = "off",
    hidden = true,
    number = true,
    relativenumber = true,
    cmdheight = 1,
    mouse = "a",
    signcolumn = "yes",
    updatetime = 50,
    equalalways = false,
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
    foldenable = false,
    foldlevel = 1,
    scrolloff = 10,
    sidescrolloff = 5,
    spell = false,
    spelllang = "en_au,en_us",
    spelloptions = "camel,noplainbuffer",
    splitkeep = "screen",
    completeopt = "menu,menuone,preview",
})

-- Recognise _ as word separator
vim.cmd("set iskeyword-=_") -- TODO: write this in lua
vim.fn.matchadd("ColorColumn", "\\%80v", 100) -- DANGER ZONE FUCK NOT 80 CHARAC

-- Global statusline
vim.opt.fillchars:append({
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┫",
    vertright = "┣",
    verthoriz = "╋",
    eob = " ", -- TODO: Themed maybe, use icon assets
})
