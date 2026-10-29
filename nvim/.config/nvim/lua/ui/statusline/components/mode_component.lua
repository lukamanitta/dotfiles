local hl = require("ui.statusline.hl")

local MODE_NAMES = {
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

local function mode_highlight(mode)
    -- If MiniStatusline is installed, use its highlight groups for modes.
    if vim.fn.exists("g:loaded_mini_statusline") ~= 1 then
        return "RedrawDebugNormal"
    end

    if mode:find("NORMAL") then
        return "MiniStatuslineModeNormal"
    elseif mode:find("INSERT") or mode:find("SELECT") then
        return "MiniStatuslineModeInsert"
    elseif mode:find("VISUAL") then
        return "MiniStatuslineModeVisual"
    elseif mode:find("PENDING") then
        return "MiniStatuslineModeReplace"
    elseif
        mode:find("COMMAND")
        or mode:find("TERMINAL")
        or mode:find("EX")
    then
        return "MiniStatuslineModeCommand"
    end

    return "MiniStatusLineModeOther"
end

return function()
    local mode = MODE_NAMES[vim.api.nvim_get_mode().mode] or "UNKNOWN"
    return hl.hl(mode_highlight(mode), " " .. mode .. " ")
end
