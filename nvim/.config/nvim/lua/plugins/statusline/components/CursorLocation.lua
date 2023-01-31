return {
    provider = function()
        local line = vim.fn.line(".")
        local col = vim.fn.virtcol(".")
        -- return require("assets.icons").general.Crosshairs
        --     .. string.format(
        --         " %3d:%-2d ",
        --         line and line or "X",
        --         col and col or "X"
        --     )
        return require("assets.icons").general.Crosshairs
            .. "%7(%3l/%L%):%-2c"
            .. " "
    end,
}
