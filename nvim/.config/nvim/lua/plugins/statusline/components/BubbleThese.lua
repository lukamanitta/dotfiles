---@diagnostic disable: undefined-field, undefined-doc-name
local helpers = require("plugins.statusline.helpers")
local components = require("plugins.statusline.components")

--- Create a series of connected bubbles (one for each component given).
---@param opts table containing options for the bubble (e.g. direction).
---@vararg StatusLine components to wrap
local function BubbleThese(opts, ...)
    opts.bg = opts.bg or "NONE"
    opts.direction = opts.direction or "center"

    local bubble_components = { ... }
    local bubble = {}

    if opts.direction == "center" then
        -- Get middle component of vararg
        local middle = select(
            math.ceil(select("#", bubble_components) / 2),
            bubble_components
        )
        -- Get all components left of middle
        local left = {
            select(
                1,
                math.ceil(select("#", bubble_components) / 2) - 1,
                bubble_components
            ),
        }
        -- Get all components right of middle
        local right = {
            select(
                math.ceil(select("#", bubble_components) / 2) + 1,
                bubble_components
            ),
        }

        -- Create left and right bubbles
        local left_bubble =
        BubbleThese({ direction = "left" }, unpack(left), middle)
        bubble =
        BubbleThese({ direction = "right" }, left_bubble, unpack(right))

        -- Remove first component from bubble
        table.remove(bubble, 1)
    elseif opts.direction == "right" then
        table.insert(
            bubble,
            components.semicircle(
                "left",
                { hl = { fg = bubble_components[1].hl.bg, bg = opts.bg } }
            )
        )

        for i, component in ipairs(bubble_components) do
            table.insert(bubble, component)
            table.insert(
                bubble,
                components.semicircle("right", {
                    hl = {
                        fg = component.hl.bg,
                        bg = bubble_components[i + 1]
                            and bubble_components[i + 1].hl.bg
                            or opts.bg,
                    },
                })
            )
        end
    elseif opts.direction == "left" then
        table.insert(
            bubble,
            components.semicircle(
                "right",
                { hl = { fg = bubble_components[1].hl.bg, bg = opts.bg } }
            )
        )

        for i, component in ipairs(bubble_components) do
            table.insert(bubble, component)
            table.insert(
                bubble,
                components.semicircle("left", {
                    hl = {
                        fg = component.hl.bg,
                        bg = bubble_components[i + 1]
                            and bubble_components[i + 1].hl.bg
                            or opts.bg,
                    },
                })
            )
        end
    end

    return bubble
end

return BubbleThese
