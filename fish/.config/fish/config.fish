if status is-interactive
    # neofetch --ascii ~/.config/neofetch/ascii/small-skull.txt
end

set -g fish_greeting

set -gx EDITOR nvim

export LIBRARY_PATH="$LIBRARY_PATH:/opt/homebrew/lib"

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
