_G.fff_resume_state = {
    last_picker = nil,
    last_query = nil,
    last_opts = nil,
    last_row = 0,
}

local function picker_by_name(picker_name, opts)
    if picker_name == "find_files" then
        require("fff").find_files(opts)
    elseif picker_name == "live_grep" then
        require("fff").live_grep(opts)
    else
        vim.notify(
            "Unknown picker: " .. picker_name,
            vim.log.levels.WARN,
            { title = "FFF" }
        )
    end
end

local function state_tracked_picker(picker_name, opts)
    _G.fff_resume_state.last_picker = picker_name
    _G.fff_resume_state.last_query = ""
    _G.fff_resume_state.last_opts = opts

    picker_by_name(picker_name, opts)
end

local function resume_picker()
    local resume_state = _G.fff_resume_state
    if not resume_state.last_picker then
        vim.notify(
            "[fff.resume_picker] No cached picker",
            vim.log.levels.INFO,
            { title = "FFF" }
        )
        return
    end

    vim.api.nvim_create_autocmd("BufEnter", {
        once = true,
        callback = function()
            if resume_state.last_row and resume_state.last_row > 0 then
                vim.schedule(function()
                    pcall(
                        vim.api.nvim_win_set_cursor,
                        0,
                        { resume_state.last_row, 0 }
                    )
                end)
            end
        end,
    })

    local opts = vim.tbl_deep_extend("force", resume_state.last_opts or {}, {
        query = resume_state.last_query,
    })

    picker_by_name(resume_state.last_picker, opts)
end

local prompt_prefix = " " .. require("ui.icons").general.Search .. "  "
vim.api.nvim_create_autocmd({ "TextChangedI", "TextChangedP" }, {
    group = vim.api.nvim_create_augroup(
        "fff_resume_state_query",
        { clear = true }
    ),
    callback = function()
        if vim.bo.buftype == "prompt" and _G.fff_resume_state.last_picker then
            local current_line = vim.api.nvim_get_current_line()
            local current_query =
                current_line:gsub("^" .. vim.pesc(prompt_prefix), "")
            _G.fff_resume_state.last_query = current_query
        end
    end,
})

vim.keymap.set("n", "<LEADER>ff", function()
    state_tracked_picker("find_files", { cwd = require("h").git_root_or_cwd() })
end)

vim.keymap.set("n", "<LEADER>fg", function()
    state_tracked_picker("live_grep")
end)

vim.keymap.set("v", "<LEADER>fg", function()
    local selection = require("h").get_visual_selection()
    state_tracked_picker("live_grep", { query = selection })
end)

vim.keymap.set("n", "<LEADER>fc", function()
    state_tracked_picker("find_files", { query = "git:modified " })
end)

vim.keymap.set("n", "<LEADER>fr", function()
    resume_picker()
end)
