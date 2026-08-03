local programs = require("modules.programs")

hl.on("hyprland.start", function()
    hl.exec_cmd(
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    )
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("wl-past --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type-image --watch cliphist store")
    hl.exec_cmd("sunshine")

    hl.exec_cmd(programs.status_bar)
    hl.exec_cmd("hyprlock")
end)

hl.on("config.reloaded", function()
    hl.exec_cmd(
        'gsetting set org.gnome.desktop.interface color-scheme "prefer-dark"'
    )
    hl.exec_cmd(
        'gsetting set org.gnome.desktop.interface gtk-theme "adw-gtk-dark"'
    )
    hl.exec_cmd(
        "waypaper --restore --state-file ~/.config/waypaper/wallpaper.ini"
    )
end)
