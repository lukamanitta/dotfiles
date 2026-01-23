return function()
    local mode_to_str = {
        ["n"] = "NORMAL",
        ["no"] = "OP-PENDING",
        ["nov"] = "OP-PENDING",
        ["noV"] = "OP-PENDING",
        ["no\22"] = "OP-PENDING",
        ["niI"] = "NORMAL",
        ["niR"] = "NORMAL",
        ["niV"] = "NORMAL",
        ["nt"] = "NORMAL",
        ["ntT"] = "NORMAL",
        ["v"] = "VISUAL",
        ["vs"] = "VISUAL",
        ["V"] = "VISUAL",
        ["Vs"] = "VISUAL",
        ["\22"] = "VISUAL",
        ["\22s"] = "VISUAL",
        ["s"] = "SELECT",
        ["S"] = "SELECT",
        ["\19"] = "SELECT",
        ["i"] = "INSERT",
        ["ic"] = "INSERT",
        ["ix"] = "INSERT",
        ["R"] = "REPLACE",
        ["Rc"] = "REPLACE",
        ["Rx"] = "REPLACE",
        ["Rv"] = "VIRT REPLACE",
        ["Rvc"] = "VIRT REPLACE",
        ["Rvx"] = "VIRT REPLACE",
        ["c"] = "COMMAND",
        ["cv"] = "VIM EX",
        ["ce"] = "EX",
        ["r"] = "PROMPT",
        ["rm"] = "MORE",
        ["r?"] = "CONFIRM",
        ["!"] = "SHELL",
        ["t"] = "TERMINAL",
    }

    local mode = mode_to_str[vim.api.nvim_get_mode().mode] or "UNKNOWN"

    local hl = "MiniStatusLineModeOther"
    if mode:find("NORMAL") then
        hl = "MiniStatuslineModeNormal"
    elseif mode:find("INSERT") or mode:find("SELECT") then
        hl = "MiniStatuslineModeInsert"
    elseif mode:find("VISUAL") then
        hl = "MiniStatuslineModeVisual"
    elseif mode:find("PENDING") then
        hl = "MiniStatuslineModeReplace"
    elseif mode:find("COMMAND") or mode:find("TERMINAL") or mode:find("EX") then
        hl = "MiniStatuslineModeCommand"
    end

    return string.format("%%#%s# %s %%#Statusline#", hl, mode)
end
