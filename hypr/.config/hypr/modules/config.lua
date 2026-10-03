local theme = require("theme.colourme")

hl.config({
    general = {
        gaps_in = 4,
        gaps_out = {
            top = 3,
            right = 8,
            bottom = 8,
            left = 8,
        },
        border_size = 2,
        -- https://wiki.hypr.land/Configuring/Variables/#variable-types for info about colors
        -- col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        -- col.inactive_border = rgba(595959aa)
        -- Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,
        -- Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
        allow_tearing = false,
        layout = "dwindle",
        col = {
            active_border = theme.activeBorderColor,
        },
    },
    -- https://wiki.hypr.land/Configuring/Variables/#decoration
    decoration = {
        rounding = 8,
        rounding_power = 2,
        -- Change transparency of focused and unfocused windows
        active_opacity = 1.0,
        inactive_opacity = 0.96,
        -- shadow {
        --     enabled = true
        --     range = 4
        --     render_power = 3
        --     color = rgba(1a1a1aee)
        -- }
        -- https://wiki.hypr.land/Configuring/Variables/#blur
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
        shadow = {
            color = "rgba(15, 15, 15, 0.6)",
            color_inactive = "rgba(15, 15, 15, 0.3)",
            offset = {
                2,
                2,
            },
            range = 11,
            render_power = 2,
        },
    },
    group = {
        col = {
            border_active = theme.activeBorderColor,
        },
    },
    -- https://wiki.hypr.land/Configuring/Variables/#animations
    animations = {
        enabled = true,
    },
    master = {
        new_status = "master",
    },
    -- https://wiki.hypr.land/Configuring/Variables/#misc
    misc = {
        middle_click_paste = false,
        force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
        -- Stamp launched processes with the workspace they were invoked on, so
        -- apps open where the user was, even if focus moves before the window
        -- maps (e.g. the launcher's layer surface closing).
        initial_workspace_tracking = 1,
        -- Don't let passive mouse movement re-focus the monitor under the
        -- cursor. Together with cursor:no_warps this lets keyboard workspace
        -- switches move focus to an empty workspace on another monitor without
        -- dragging the pointer along. Clicking a window still focuses it.
        mouse_move_focuses_monitor = false,
    },
    --############
    --## INPUT ###
    --############
    -- https://wiki.hypr.land/Configuring/Variables/#input
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        repeat_delay = 180,
        repeat_rate = 35,
        follow_mouse = 2,
        sensitivity = -0.7, -- -1.0 - 1.0, 0 means no modification.
        touchpad = {
            natural_scroll = false,
        },
    },
    cursor = {
        hide_on_key_press = true,
        -- Keep the cursor still when switching workspaces; monitor focus is
        -- handled by misc:mouse_move_focuses_monitor (see below) instead.
        no_warps = true,
    },
})
