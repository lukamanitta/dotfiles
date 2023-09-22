if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path ~/bin/

set -g fish_greeting

set -gx EDITOR kak

source /opt/homebrew/opt/asdf/libexec/asdf.fish

alias lg="lazygit"

starship init fish | source
