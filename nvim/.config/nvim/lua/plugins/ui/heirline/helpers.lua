local U = {}
local conditions = require("heirline.conditions")

function U.mode_colour()
    local mode = conditions.is_active() and vim.fn.mode() or "n"
    return require("plugins.ui.heirline.consts").mode_colour[mode]
end

function U.mode_shortname()
    local mode = conditions.is_active() and vim.fn.mode() or "n"
    return require("plugins.ui.heirline.consts").mode_shortnames[mode]
end

function U.component_hl(component)
    local hl = component.hl
    if type(hl) == "table" then
        return hl
    elseif type(hl) == "function" then
        return component:hl()
    end
    return hl
end

function U.build_semicircle_hl(component, bg)
    local semicircle_hl
    if type(component.hl) == "table" then
        semicircle_hl = {
            fg = component.hl.bg,
            bg = bg ~= "" and bg or "NONE",
        }
    elseif type(component.hl) == "function" then
        semicircle_hl = function()
            local hl = component:hl()
            return {
                fg = hl.bg,
                bg = bg ~= "" and bg or "NONE",
            }
        end
    end

    return semicircle_hl
end

function U.get_inverted_hl(component)
    local hl = component.hl
    if type(hl) == "table" then
        return {
            fg = hl.bg,
            bg = hl.fg,
        }
    elseif type(hl) == "function" then
        return function()
            hl = component:hl()
            return {
                fg = hl.bg,
                bg = hl.fg,
            }
        end
    end
    return hl
end

function U.modify_hl(component, fg, bg)
    local hl = component.hl
    local new_hl
    if type(hl) == "table" then
        new_hl = {
            fg = fg or hl.fg,
            bg = bg or hl.bg,
        }
    elseif type(hl) == "function" then
        new_hl = function()
            hl = component:hl()
            return {
                fg = fg or hl.fg,
                bg = bg or hl.bg,
            }
        end
    end
    component.hl = new_hl
end

return U
