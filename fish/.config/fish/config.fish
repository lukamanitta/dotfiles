if status is-interactive
    # Commands to run in interactive sessions can go here
    rbenv init - fish | source
end


set -g fish_greeting

set -gx EDITOR kak

source /opt/homebrew/opt/asdf/libexec/asdf.fish

fish_add_path ~/bin/

alias lg="lazygit"

# MSI stuff
source "$(brew --prefix)/share/google-cloud-sdk/path.fish.inc"
fish_add_path ~/code/msi-utils/bin/

starship init fish | source
