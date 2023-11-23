local U = {}

function inside_git_dir()
    local _ = vim.fn.system("git rev-parse --is-inside-git-dir")
    return vim.v.shell_error == 0
end

function U.smart_file_finder(opts)
    opts = opts or {}
    local inside_git_dir = inside_git_dir()
    if inside_git_dir then
        require("telescope.builtin").git_files(opts)
    else
        require("telescope.builtin").find_files(opts)
    end
end

function U.git_modified_finder(opts)
    opts = opts or {}
    local git_modified_opts = vim.tbl_deep_extend("keep", opts, {
        git_command = {
            "git",
            "ls-files",
            "--modified",
            "--full-name",
            "--exclude-standard",
        }
    })
    
    require("telescope.builtin").git_files(git_modified_opts)
end
