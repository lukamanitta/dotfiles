hl.window_rule({
    name = "PiP-opacity",
    match = {
        title = "^(Picture-in-Picture)$",
    },
    float = true,
    pin = true,
    persistent_size = true,
    opaque = true,
    keep_aspect_ratio = true,
})

hl.window_rule({
    name = "YouTube-opacity",
    match = {
        title = ".*YouTube.*",
    },
    opaque = true,
})

hl.window_rule({
    name = "Affinity-opacity",
    match = {
        title = ".*Affinity.*",
    },
    opaque = true,
})

hl.window_rule({
    name = "scratch",
    match = {
        title = "^scratch$",
    },
    float = true,
    pin = true,
    persistent_size = false,
    opaque = true,
})

hl.window_rule({
    name = "suppress-maximize-events",
    match = {
        class = ".*",
    },
    -- Ignore maximize requests from all apps. You'll probably like this.
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    -- Fix some dragging issues with XWayland
    no_focus = true,
})

hl.window_rule({
    name = "move-hyprland-run",
    match = {
        class = "hyprland-run",
    },
    move = "20 monitor_h-120",
    float = true,
})
