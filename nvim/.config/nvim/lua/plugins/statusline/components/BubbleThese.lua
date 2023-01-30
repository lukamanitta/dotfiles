---@diagnostic disable: undefined-field, undefined-doc-name
local helpers = require("plugins.statusline.helpers")
local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local Semicircle = require("plugins.statusline.components.Semicircle")
local SingleSpace = require("plugins.statusline.components.SingleSpace")
local BubbleThis = require("plugins.statusline.components.BubbleThis")

--- Create a series of connected bubbles (one for each component given).
---@param opts table containing options for the bubble (e.g. direction).
---@vararg StatusLine components to wrap
local function BubbleThese(opts, ...)
    opts.direction = opts.direction or "center"
    opts.end_bgs = opts.end_bgs and opts.end_bgs
        or { get_hi_group_bg("StatusLine"), get_hi_group_bg("StatusLine") }
    if #opts.end_bgs == 1 then
        opts.end_bgs[2] = opts.end_bgs[1]
    end

    local bubble_components = { ... }
    local bubble = {}

    -- WIP: Center doesn't work yet
    if opts.direction == "center" then
        -- Get middle component of vararg
        local middle = bubble_components[math.ceil(#bubble_components / 2)]

        -- Get all components left of middle
        local left = {
            unpack(bubble_components, 1, math.ceil(#bubble_components / 2) - 1),
        }

        -- Get all components right of middle
        local right = {
            unpack(
                bubble_components,
                math.ceil(#bubble_components / 2) + 1,
                #bubble_components
            ),
        }

        -- Create left and right bubbles
        local left_bubble =
        BubbleThese({ direction = "left" }, unpack(left), middle)
        bubble =
        BubbleThese({ direction = "right" }, left_bubble, unpack(right))
    elseif opts.direction == "right" then
        for i, component in ipairs(bubble_components) do
            local bubbled_component = BubbleThis(component, {
                opts.end_bgs[1],
                bubble_components[i + 1] and helpers.component_hl(
                    bubble_components[i + 1]
                ).bg or opts.end_bgs[2],
            })

            if i ~= 1 then
                bubbled_component[1].provider = " "
                bubbled_component[1].hl = bubbled_component[2].hl
            end

            table.insert(bubble, bubbled_component)
        end
    elseif opts.direction == "left" then
        for i, component in ipairs(bubble_components) do
            local bubbled_component = BubbleThis(component, {
                bubble_components[i - 1] and helpers.component_hl(
                    bubble_components[i - 1]
                ).bg or opts.end_bgs[1],
                opts.end_bgs[2],
            })

            if i ~= #bubble_components then
                bubbled_component[#bubbled_component].provider = " "
                bubbled_component[#bubbled_component].hl =
                bubbled_component[2].hl
            end

            table.insert(bubble, bubbled_component)
        end
    end

    return bubble
end

return BubbleThese
