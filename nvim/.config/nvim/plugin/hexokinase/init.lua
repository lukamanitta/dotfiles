vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        if ev.data.spec.name == "vim-hexokinase" then
            vim.system({ "make", "hexokinase", "-C", ev.data.path }):wait()
            vim.notify(
                "hexokinase built successfully",
                vim.log.levels.INFO,
                { title = "Pack" }
            )
        end
    end,
})

vim.pack.add({
    { src = "https://github.com/RRethy/vim-hexokinase" },
})
