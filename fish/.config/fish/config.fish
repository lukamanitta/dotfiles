if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g fish_greeting

set -gx EDITOR nvim

source ~/.asdf/asdf.fish
# Do this if link isn't already made
# mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions

fish_add_path ~/bin/
fish_add_path ~/.pub-cache/bin/

source ~/.env

alias lg="lazygit"

# MSI stuff
source "$(brew --prefix)/share/google-cloud-sdk/path.fish.inc"
fish_add_path ~/code/msi-utils/bin/

starship init fish | source
