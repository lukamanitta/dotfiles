if status is-interactive
    # neofetch --ascii ~/.config/neofetch/ascii/small-skull.txt
end

set -g fish_greeting

set -gx EDITOR nvim

if type -q brew
	export LIBRARY_PATH="$LIBRARY_PATH:/opt/homebrew/lib"
end

# MSI stuff
if test -d ~/code/msi-utils/bin
	source "$(brew --prefix)/share/google-cloud-sdk/path.fish.inc"
	fish_add_path ~/code/msi-utils/bin/
end

source ~/.asdf/asdf.fish
# Do this if link isn't already made
# mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions

fish_add_path ~/.local/bin/
fish_add_path ~/.pub-cache/bin/

if test -f ~/.env
	source ~/.env
end

alias lg="lazygit"

if not type -q starship
	curl -sS https://starship.rs/install.sh | sh
end

starship init fish | source
