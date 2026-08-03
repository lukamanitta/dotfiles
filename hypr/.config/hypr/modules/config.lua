hl.config({
    general = {
        gaps_in = 4,
        gaps_out = "3,8,8,8",
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
            active_border = activeBorderColor,
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
            offset = "2 2",
            range = 11,
            render_power = 2,
        },
    },
    group = {
        col = {
            border_active = activeBorderColor,
        },
    },
    -- https://wiki.hypr.land/Configuring/Variables/#animations
    animations = {
        enabled = "yes, please :)",
        -- Default curves, see https://wiki.hypr.land/Configuring/Animations/#curves
        --        NAME,           X0,   Y0,   X1,   Y1
        -- Default animations, see https://wiki.hypr.land/Configuring/Animations/
        --           NAME,          ONOFF, SPEED, CURVE,        [STYLE]
    },
    -- Ref https://wiki.hypr.land/Configuring/Workspace-Rules/
    -- "Smart gaps" / "No gaps when only"
    -- uncomment all if you wish to use that.
    -- workspace = w[tv1], gapsout:0, gapsin:0
    -- workspace = f[1], gapsout:0, gapsin:0
    -- windowrule {
    --     name = no-gaps-wtv1
    --     match:float = false
    --     match:workspace = w[tv1]
    --
    --     border_size = 0
    --     rounding = 0
    -- }
    --
    -- windowrule {
    --     name = no-gaps-f1
    --     match:float = false
    --     match:workspace = f[1]
    --
    --     border_size = 0
    --     rounding = 0
    -- }
    -- See https://wiki.hypr.land/Configuring/Dwindle-Layout/ for more
    -- dwindle {
    --     pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    --     preserve_split = true # You probably want this
    -- }
    -- See https://wiki.hypr.land/Configuring/Master-Layout/ for more
    master = {
        new_status = "master",
    },
    -- https://wiki.hypr.land/Configuring/Variables/#misc
    misc = {
        middle_click_paste = false,
        force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
        initial_workspace_tracking = 0,
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
        no_warps = true,
    },
})
