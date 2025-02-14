local wezterm = require("wezterm")
local U = {}

function U.combine_tables(...)
    local combined = {}

    --- Loop through each table
    for _, tbl in ipairs({ ... }) do
        -- Copy the table into the combined table
        for k, v in pairs(tbl) do
            combined[k] = v
        end
    end

    -- Return the combined table
    return combined
end

function U.is_linux()
    return wezterm.target_triple:find("linux") ~= nil
end

function U.is_darwin()
    return wezterm.target_triple:find("darwin") ~= nil
end

return U
