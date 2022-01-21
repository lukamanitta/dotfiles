#!/usr/bin/env bash

# Cleanup all old legacy stuff first
echo "Removing redundant / incomplete symlinks..."
for i in $(find "$HOME" -maxdepth 1 -type l);
do
    found=$(readlink -e "$i")
    if [ -z "$found" ]
    then
        echo "  REMOVED: $i symlink, destination not found"
        rm "$i"
    fi
done

set -e

# Cleanup ~/ files
echo "Removing old config files..."
for i in .zshrc .bashrc .vimrc .gitignore_global .config/starship.toml
do
    [ -f "$HOME/$i" ] && rm "$HOME/$i" && echo "  REMOVED: $HOME/$i"
done

# echo "Removing old .config directories..."
# for i in .config/nvim/ .config/wezterm/ .config/zsh/
# do
#     if [[ "$i" = "/" ]]; then
#         echo "A dirname expanded to '/', which would destroy everything, so maybe don't do that"
#         exit
#     fi
#     [ -d "$HOME/$i" ] && rm -rf "$HOME/$i" && echo "  REMOVED: $HOME/.config/$i"
# done

# Stow dotfiles
echo "Stowing dotfiles..."

stow stow && echo "  STOWED: stow"
stow nvim && echo "  STOWED: nvim"
stow bash && echo "  STOWED: bash"
stow starship && echo "  STOWED: starship"
stow zsh && echo "  STOWED: zsh"
stow wezterm && echo "  STOWED: wezterm"
stow git && echo "  STOWED: git"
stow vim && echo "  STOWED: vim"
stow lazygit && echo "  STOWED: lazygit"
# stow tmux && echo "  STOWED: tmux"

echo "Checking local_env_vars..."

if [ ! -f "$HOME"/.local_env_vars ]; then
    echo "  .local_env_vars doesn't exist, copying template..."
    cp .local_env_vars_template "$HOME"/.local_env_vars
else
    echo "  .local_env_vars already exists, skipping..."
fi

echo "Configuring global gitignore..."
git config --global core.excludesfile ~/.gitignore_global

echo "Finished set-up!"
