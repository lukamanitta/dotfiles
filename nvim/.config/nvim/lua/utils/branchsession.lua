local function isInsideGitProject()
    local _ = vim.fn.system("git rev-parse --is-inside-work-tree")
    if vim.v.shell_error == 0 then
        return true
    else
        return false
    end
end

local function getProjectName()
    return vim.fn.fnamemodify(
        vim.fn.system("git rev-parse --show-toplevel | tr -d '\n'"),
        ":t"
    )
end

local function generateSessionFileName()
    local vim_session_dir = vim.fn.expand("~/.nvim-sessions/")
    local branch =
    require("utils.helpers").shell("git rev-parse --abbrev-ref HEAD")
    local this_session_dir = vim_session_dir .. getProjectName() .. "/"

    -- Create project session dir if doesn't exist
    vim.fn.system("mkdir " .. this_session_dir .. " > /dev/null 2>&1")

    return this_session_dir .. branch .. ".vim"
end

local function saveBranchSession()
    if isInsideGitProject() then
        vim.cmd("mksession! " .. generateSessionFileName())
    else
        vim.notify("Need to be inside git project!", vim.log.levels.ERROR)
    end
end

local function loadBranchSession()
    if isInsideGitProject() then
        vim.cmd("source " .. generateSessionFileName())
    else
        vim.notify("Need to be inside git project!", vim.log.levels.ERROR)
    end
end

local function deleteBranchSession()
    if isInsideGitProject() then
        vim.cmd("silent! !rm " .. generateSessionFileName())
    else
        vim.notify("Need to be inside git project!", vim.log.levels.ERROR)
    end
end

vim.api.nvim_create_user_command("BranchSessionSave", function()
    saveBranchSession()
end, { nargs = 0 })
vim.api.nvim_create_user_command("BranchSessionLoad", function()
    loadBranchSession()
end, { nargs = 0 })
vim.api.nvim_create_user_command("BranchSessionDelete", function()
    deleteBranchSession()
end, { nargs = 0 })
