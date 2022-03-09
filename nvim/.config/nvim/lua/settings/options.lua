local apply_options = require('utils.config').apply_options

apply_options({
    syntax = 'off',
    hidden = true,
    number = true,
    relativenumber = true,
    mouse = 'a',
    signcolumn = 'yes',
    updatetime = 50,
    noequalalways = true,
    splitbelow = true,
    lazyredraw = true,
    ttyfast = true,
    termguicolors = true,
    cursorline = true,
    laststatus = 2,
    incsearch = true,
    inccommand = 'nosplit',
    encoding = 'utf-8',
    expandtab = true, -- Expand tabs to spaces
    shiftwidth = 4, -- Tab = 4 spaces
    backspace = 'indent,eol,start',
    belloff = 'all', -- Shut that fucking bell sound off
    foldmethod = 'indent',
    foldnestmax = 10,
    nofoldenable = true,
    foldlevel = 1,
    scrolloff = 8,
    sidescrolloff = 5,
    spelllang = 'en_au',
})

vim.fn.matchadd('ColorColumn', '\\%80v', 100) -- DANGER XONE FUCK NOT 80 CHARAC
