local function get_project_name()
    return vim.fn.fnamemodify(
        vim.fn.system("git rev-parse --show-toplevel | tr -d '\n'"),
        ":t"
    )
end

local function generate_session_filename()
    local vim_session_dir = vim.fn.expand("~/.nvim-sessions/")
    local branch =
    require("utils.helpers").shell("git rev-parse --abbrev-ref HEAD")
    local this_session_dir = vim_session_dir .. get_project_name() .. "/"

    -- Create project session dir if doesn't exist
    vim.fn.system("mkdir " .. this_session_dir .. " > /dev/null 2>&1")

    return this_session_dir .. branch .. ".vim"
end

local function save_branch_session()
    if require("utils.helpers").inside_git_dir() then
        vim.cmd("mksession! " .. generate_session_filename())
    else
        vim.notify("Need to be inside git project!", vim.log.levels.ERROR)
    end
end

local function load_branch_session()
    if require("utils.helpers").inside_git_dir() then
        vim.cmd("source " .. generate_session_filename())
    else
        vim.notify("Need to be inside git project!", vim.log.levels.ERROR)
    end
end

local function delete_branch_session()
    if require("utils.helpers").inside_git_dir() then
        vim.cmd("silent! !rm " .. generate_session_filename())
    else
        vim.notify("Need to be inside git project!", vim.log.levels.ERROR)
    end
end

vim.api.nvim_create_user_command("BranchSessionSave", function()
    save_branch_session()
end, { nargs = 0 })
vim.api.nvim_create_user_command("BranchSessionLoad", function()
    load_branch_session()
end, { nargs = 0 })
vim.api.nvim_create_user_command("BranchSessionDelete", function()
    delete_branch_session()
end, { nargs = 0 })
