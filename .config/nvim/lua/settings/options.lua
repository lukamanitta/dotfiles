local apply_options = require('utils.config').apply_options

apply_options({
    guifont = 'RobotoMono\\ Nerd\\ Font:h15',
    syntax = 'on',
    hidden = true,
    number = true,
    relativenumber = true,
    nocp = true,
    mouse = 'a',
    signcolumn = 'yes',
    updatetime = 50,
    noequalalways = true,
    splitbelow = true,
    lazyredraw = true,
    ttyfast = true,
    re = 1,
    termguicolors = true,
    cursorline = true,
    laststatus = 2,
    encoding = 'utf-8',
    expandtab = true, -- Expand tabs to spaces
    shiftwidth = 4, -- Tab = 4 spaces
    backspace = 'indent,eol,start',
    belloff = 'all', -- Shut that fucking bell sound off
    colorcolumn = '80,100', -- Line length DANGER ZONE NO PLS NO FUCK AHH NOT 80
    foldmethod = 'indent',
    foldnestmax = 10,
    nofoldenable = true,
    foldlevel = 1,
})
