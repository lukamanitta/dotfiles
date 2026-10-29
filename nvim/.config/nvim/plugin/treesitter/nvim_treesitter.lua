-- pack add treesitter, treesitter-context, and ts-context-commenstring
vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

local treesitter = require("nvim-treesitter")
treesitter.setup({})

-- https://www.reddit.com/r/neovim/comments/1pndf9e/my_new_nvimtreesitter_configuration_for_the_main/
local PARSERS = {
    "lua",
    "rust",
    "ruby",
    "python",

    "bash",

    "tsx",
    "svelte",

    "javascript",
    "typescript",

    "html",
    "css",
    "scss",

    "json",
    "yaml",
    "toml",

    "markdown",
    "markdown_inline",
}

local UPDATE_INTERVAL = 7 * 24 * 60 * 60
local PROMPT_INTERVAL = 24 * 60 * 60
local STATE_FILE = vim.fn.stdpath("state") .. "/nvim-treesitter-update.json"

local function read_state()
    local ok, lines = pcall(vim.fn.readfile, STATE_FILE)
    if not ok or not lines or #lines == 0 then
        return {}
    end

    local decoded_ok, state = pcall(vim.json.decode, table.concat(lines, "\n"))
    if not decoded_ok or type(state) ~= "table" then
        return {}
    end

    return state
end

local function write_state(state)
    pcall(vim.fn.mkdir, vim.fn.fnamemodify(STATE_FILE, ":h"), "p")

    local ok, encoded = pcall(vim.json.encode, state)
    if ok then
        pcall(vim.fn.writefile, { encoded }, STATE_FILE)
    end
end

local state = read_state()
local suppress_update_event = false

local function notify(message, level)
    vim.schedule(function()
        vim.notify(message, level, { title = "Treesitter" })
    end)
end

local function mark_updated()
    state.last_update = os.time()
    state.last_prompt = nil
    write_state(state)
end

local function run_update()
    if suppress_update_event then
        state.last_prompt = os.time()
        write_state(state)
        notify("Treesitter is already updating", vim.log.levels.INFO)
        return
    end

    suppress_update_event = true

    local task = treesitter.update()
    task:await(function(err, ok)
        vim.schedule(function()
            suppress_update_event = false

            if err or not ok then
                state.last_prompt = os.time()
                write_state(state)
                notify("Treesitter parser update failed", vim.log.levels.ERROR)
                return
            end

            mark_updated()
            notify("Treesitter parsers updated", vim.log.levels.INFO)
        end)
    end)
end

local function start_for_buffer(bufnr)
    local lang = vim.treesitter.language.get_lang(
        vim.api.nvim_get_option_value("filetype", { buf = bufnr })
    )

    if
        lang
        and not vim.b[bufnr].ts_highlight
        and vim.list_contains(treesitter.get_installed(), lang)
    then
        vim.treesitter.start(bufnr)
    end
end

local function install_missing_parsers()
    local installed = treesitter.get_installed()
    local missing = {}

    for _, lang in ipairs(PARSERS) do
        if not vim.list_contains(installed, lang) then
            table.insert(missing, lang)
        end
    end

    if #missing == 0 then
        return
    end

    suppress_update_event = true

    local task = treesitter.install(missing)
    task:await(function(err, ok)
        vim.schedule(function()
            suppress_update_event = false

            if err or not ok then
                notify(
                    "Failed to install Treesitter parsers: "
                        .. table.concat(missing, ", "),
                    vim.log.levels.ERROR
                )
                return
            end

            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(bufnr) then
                    start_for_buffer(bufnr)
                end
            end

            notify(
                "Installed Treesitter parsers: " .. table.concat(missing, ", "),
                vim.log.levels.INFO
            )
        end)
    end)
end

local function maybe_prompt_update()
    -- Headless/scripted Neovim cannot answer prompts.
    if #vim.api.nvim_list_uis() == 0 then
        return
    end

    local now = os.time()
    if now - (state.last_update or 0) < UPDATE_INTERVAL then
        return
    end

    if now - (state.last_prompt or 0) < PROMPT_INTERVAL then
        return
    end

    vim.ui.select({ "Update now", "Later" }, {
        prompt = "Treesitter parsers have not been updated in 7 days. Update now?",
    }, function(choice)
        if choice == "Update now" then
            run_update()
        else
            state.last_prompt = os.time()
            write_state(state)
        end
    end)
end

-- Running `:TSUpdate` manually also refreshes the prompt timestamp.
vim.api.nvim_create_autocmd("User", {
    pattern = "TSUpdate",
    callback = function()
        if suppress_update_event then
            return
        end
        mark_updated()
    end,
})

install_missing_parsers()

vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        vim.schedule(maybe_prompt_update)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        start_for_buffer(args.buf)
    end,
    desc = "Enable nvim-treesitter for supported filetypes",
})
