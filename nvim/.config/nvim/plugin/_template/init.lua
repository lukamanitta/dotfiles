-- vim.api.nvim_create_autocmd("PackChanged", {
--     callback = function(ev)
--         if ev.data.spec.name == "<plugin-name>" then
--             vim.system({ "make", "-C", ev.data.path }):wait()
--             vim.notify(
--                 "<plugin-name> built successfully",
--                 vim.log.levels.INFO,
--                 { title = "Pack" }
--             )
--         end
--     end,
-- })

-- vim.pack.add({
--     { src = "<plugin-dependency>" },
-- })

-- vim.pack.add({
--     {
--         src = "<plugin-repo>",
--     },
-- })

-- require("<plugin-name>").setup({
-- })
