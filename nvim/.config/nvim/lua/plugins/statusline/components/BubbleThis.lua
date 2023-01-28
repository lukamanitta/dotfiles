---@diagnostic disable: undefined-field, undefined-doc-name
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local helpers = require("plugins.statusline.helpers")
local components = require("plugins.statusline.components")

--- Add circular separators to either side of a StatusLine component.
---@param component StatusLine component to wrap
return function(component, edge_bgs)
    local bubble_components = {}
    edge_bgs = edge_bgs and edge_bgs or { get_hi_group_bg("StatusLine") }

    local semicircle_update = component.update and component.update or nil

    table.insert(
        bubble_components,
        components.Semicircle("left", {
            hl = helpers.build_semicircle_hl(component, edge_bgs[1]),
            update = semicircle_update,
        })
    )
    table.insert(bubble_components, component)

    table.insert(
        bubble_components,
        components.Semicircle("right", {
            hl = helpers.build_semicircle_hl(
                component,
                edge_bgs[2] and edge_bgs[2] or edge_bgs[1]
            ),
            update = semicircle_update,
        })
    )

    return bubble_components
end
