local icons = require("ui.icons")

local git_head_name = ""
local current_root
local current_cwd

local function set_name(name)
    git_head_name = name
    if vim.v.vim_did_enter == 1 then
        vim.cmd.redrawstatus()
    end
end

local function fallback_name(path)
    return string.format(
        "%s %s",
        icons.filesystem.Folder,
        vim.fs.basename(path or vim.fn.getcwd())
    )
end

local function refresh()
    if
        vim.bo.filetype == "TelescopePrompt"
        or vim.bo.filetype == "neo-tree"
    then
        return
    end

    local root = vim.fs.root(0, ".git")
    local cwd = vim.fn.getcwd()

    if root == current_root and (root ~= nil or cwd == current_cwd) then
        return
    end

    current_root = root
    current_cwd = cwd

    if not root then
        set_name(fallback_name(cwd))
        return
    end

    local ok = pcall(
        vim.system,
        { "git", "-C", root, "rev-parse", "--abbrev-ref", "HEAD" },
        { text = true },
        function(result)
            vim.schedule(function()
                if current_root ~= root then
                    return
                end

                local head = result.stdout and result.stdout:gsub("%s+$", "")
                if result.code ~= 0 or not head or head == "" then
                    set_name(fallback_name(root))
                    return
                end

                set_name(string.format("%s %s", icons.git.Branch, head))
            end)
        end
    )

    if not ok then
        set_name(fallback_name(root))
    end
end

vim.api.nvim_create_autocmd(
    { "VimEnter", "DirChanged", "BufEnter", "BufWinEnter" },
    {
        group = vim.api.nvim_create_augroup(
            "git_head_component",
            { clear = true }
        ),
        pattern = "*",
        callback = refresh,
    }
)

return function()
    return git_head_name
end
