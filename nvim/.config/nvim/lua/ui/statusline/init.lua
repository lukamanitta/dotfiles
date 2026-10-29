local mode = require("ui.statusline.components.mode_component")
local git_head = require("ui.statusline.components.git_head_component")
local diagnostics =
    require("ui.statusline.components.lsp_diagnostics_component")
local lsp_server = require("ui.statusline.components.lsp_server_name")
local filetype = require("ui.statusline.components.filetype_component")
local file_progress =
    require("ui.statusline.components.file_progress_component")

local U = {}

function U.render()
    return table.concat({
        mode(),
        git_head(),
        diagnostics(),
        "%#StatusLine#%=",
        lsp_server(),
        filetype(),
        file_progress() .. " ",
    }, "   ")
end

vim.o.statusline = "%!v:lua.require'ui.statusline'.render()"
return U
