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

if test -z $ASDF_DATA_DIR
	set _asdf_shims "$HOME/.asdf/shims"
	# set -gx ASDF_DATA_DIR ~/.asdf/
else
	set _asdf_shims "$ASDF_DATA_DIR/shims"
end

if not contains $_asdf_shims $PATH
	set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

# Do this once if completions aren't configured
# asdf completion fish > ~/.config/fish/completions/asdf.fish

fish_add_path ~/bin/
fish_add_path ~/.local/bin/
fish_add_path ~/.pub-cache/bin/

if test -f ~/.env
	source ~/.env
end

alias lg="lazygit"

if not type -q starship
	curl -sS https://starship.rs/install.sh | sh
end

source ~/.config/fish/env/set_gemini_api_key.fish

starship init fish | source
