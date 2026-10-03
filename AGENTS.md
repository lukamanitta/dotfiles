# Dotfiles — agent notes

Stow-managed dotfiles. The live desktop is Hyprland (`hypr/.config/hypr/`, Lua
modules) plus a Quickshell pill/bar (`quickshell/.config/quickshell/`).

- **Debugging or changing the shell or the compositor?** Read
  `quickshell/.config/quickshell/DEBUGGING.md` first — the test loop, the
  techniques for driving a UI you cannot click, and the Hyprland 0.56 (Lua)
  traps.
- **Status / backlog:** `quickshell/.config/quickshell/PLANNING.md`.
- **Theme colours are generated:** edit
  `colourme/.config/colourme/templates/quickshell.qml`, never
  `_Shared/Singletons/Colours.qml`.
