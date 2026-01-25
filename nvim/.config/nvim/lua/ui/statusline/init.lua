local U = {}

function U.render()
    return table.concat({
        require("ui.statusline.components.mode_component")(),
        require("ui.statusline.components.git_head_component")(),
        require("ui.statusline.components.lsp_diagnostics_component")(),
        "%#StatusLine#%=",
        require("ui.statusline.components.lsp_server_name")(),
        require("ui.statusline.components.filetype_component")(),
        table.concat({
            table.concat({
                require("ui.statusline.components.file_progress_component")(),
                " ",
            }),
            -- require("ui.statusline.components.position_component")(),
        }),
    }, "   ")
end

vim.o.statusline = "%!v:lua.require'ui.statusline'.render()"
return U
