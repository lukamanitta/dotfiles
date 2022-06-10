local split_file_path = require("utils.helpers").split_file_path
local cmd = vim.cmd

local file_run_actions = {
    py = function(filepath)
        cmd("!python3 " .. filepath)
    end,
}

local function run(filepath)
    local _, filename, file_ext = split_file_path(filepath)
    if file_run_actions[file_ext] ~= nil then
        file_run_actions[file_ext](filepath)
    else
        vim.notify(
            "[" .. filename .. "] There is no run function defined for this filetype",
            4 -- Error level
        )
    end
end

return run
