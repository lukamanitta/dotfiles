local apply_globals = require("utils.config").apply_globals

apply_globals({
    lazygit_floating_window_winblend = 0, -- Transparency of floating window
    lazygit_floating_window_scaling_factor = 0.9,
    lazygit_floating_window_corner_chars = { "╭", "╮", "╰", "╯" },
    lazygit_floating_window_use_plenary = 0,
    lazygit_use_neovim_remote = 1,
})
