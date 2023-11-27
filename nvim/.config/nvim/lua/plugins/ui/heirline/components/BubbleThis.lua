---@diagnostic disable: undefined-field, undefined-doc-name
local get_hl = require("helpers").get_hl
local helpers = require("plugins.ui.heirline.helpers")
local Semicircle = require("plugins.ui.heirline.components.Semicircle")

--- Add circular separators to either side of a StatusLine component.
---@param component StatusLine component to wrap
return function(component, edge_bgs)
    local bubble_components = {
        condition = component.condition
    }
    edge_bgs = edge_bgs and edge_bgs
        or { get_hl("StatusLine", "bg#"), get_hl("StatusLine", "bg#") }
    if #edge_bgs == 1 then
        edge_bgs[2] = edge_bgs[1]
    end

    local semicircle_update = component.update and component.update or nil

    local left_hl_component = component
    local right_hl_component = component

    -- If there is no hl, then check for nested components and find the leftmost
    -- one with an hl.
    if not component.hl then
        local i = 1
        while not left_hl_component.hl and i <= #component do
            left_hl_component = component[i]
            i = i + 1
        end
        i = #component
        while not right_hl_component.hl and i > 1 do
            right_hl_component = component[i]
            i = i - 1
        end
    end

    table.insert(
        bubble_components,
        Semicircle("left", {
            -- hl = helpers.build_semicircle_hl(component, edge_bgs[1]),
            hl = function()
                return {
                    fg = helpers.component_hl(left_hl_component).bg,
                    bg = edge_bgs[1],
                }
            end,
            update = semicircle_update,
        })
    )

    table.insert(bubble_components, component)

    table.insert(
        bubble_components,
        Semicircle("right", {
            hl = function()
                return {
                    fg = helpers.component_hl(right_hl_component).bg,
                    bg = edge_bgs[2],
                }
            end,
            update = semicircle_update,
        })
    )

    return bubble_components
end
