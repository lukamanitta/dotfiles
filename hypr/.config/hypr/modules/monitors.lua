local mon1 = {
    output = "DP-2",
    mode = "1920x1080@144",
    position = "0x0",
    scale = "1",
}

local mon2 = {
    output = "HDMI-A-2",
    mode = "1920x1080@111",
    position = "0x1080",
    scale = "1",
}

hl.monitor(mon1)
hl.monitor(mon2)

local mon1Workspaces = { "1", "3", "5", "7", "9" }
local mon2Workspaces = { "2", "4", "6", "8", "10" }

for _, workspace in ipairs(mon1Workspaces) do
    hl.workspace_rule({
        workspace = workspace,
        monitor = mon1.output,
        persistent = true,
    })
end

for _, workspace in ipairs(mon2Workspaces) do
    hl.workspace_rule({
        workspace = workspace,
        monitor = mon2.output,
        persistent = true,
    })
end
