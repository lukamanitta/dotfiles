local table_merge = require("utils.config").table_merge
local previewers = require("telescope.previewers")
local Job = require("plenary.job")
local fn = vim.fn

local T = {}

function T.responsive_layout(opts)
    opts = opts or {}
    if fn.winwidth(0) < 120 then
        return require("telescope.themes").get_dropdown(opts)
    else
        return opts
    end
end

function T.smart_file_finder(opts)
    opts = opts or {}
    local git_dir = pcall(require("telescope.builtin").git_files, opts)
    if not git_dir then
        require("telescope.builtin").find_files(opts)
    end
end

function T.git_modified_finder(opts)
    opts = opts or {}
    local git_modified_opts = table_merge(opts, {
        git_command = {
            "git",
            "ls-files",
            "--modified",
            "--full-name",
            "--exclude-standard",
        },
    })
    require("telescope.builtin").git_files(git_modified_opts)
end

function T.smart_buf_preview_maker(filepath, bufnr, opts)
    opts = opts or {}
    filepath = vim.fn.expand(filepath)
    Job
        :new({
            command = "file",
            args = { "--mime-type", "-b", filepath },
            on_exit = function(j)
                local mime_type = vim.split(j:result()[1], "/")[1]
                if mime_type == "text" then
                    previewers.buffer_previewer_maker(filepath, bufnr, opts)
                else
                    -- maybe we want to write something to the buffer here
                    vim.schedule(function()
                        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
                    end)
                end
            end,
        })
        :sync()
end

return T
