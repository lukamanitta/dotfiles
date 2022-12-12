---@diagnostic disable:undefined-global

return {
    s("releaserunner", {
        fmt(
            [[
        puts 'Running {} release script'
        start = Process.clock.gettime(Process.clock::MONOTONIC)

        {}

        puts 'Finished script in #{{(Process.clock.gettime(Process.clock::MONOTONIC) - start).round(2)}} seconds'
        ]]   ,
            {
                t(vim.fn.expand("%:t:r")),
                i(0),
            }
        ),
    }),
}
