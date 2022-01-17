#!/usr/bin/env bash

# Cleanup all old legacy stuff first
echo 'Removing redundant / incomplete symlinks...'
for i in $(find $HOME -maxdepth 1 -type l);
do
    found=$(readlink -e "$i")
    if [ -z "$found" ]
    then
        echo "Unable to find destination of $i symlink, removing"
        rm "$i"
    fi
done

set -e

# Cleanup ~/ files
echo 'Removing old config files...'
for i in .zshrc .bashrc .vimrc .gitignore_global .config/starship.toml
do
    [ -f "$HOME/$i" ] && rm "$HOME/$i"
    echo "Removed $HOME/$i"
done

echo 'Removing old .config directories and files...'
for i in .config/nvim/ .config/wezterm/
do
    if [[ "$i" = / ]]; then
        echo "A filename expanded to '/', which would destroy everything"
        exit
    fi
    [ -f "$HOME/$i" ] && rm -rf ${"$HOME/$i":?}
    echo "Removed $HOME/.config/$i"
done

# Stow dotfiles
echo 'Stowing dotfiles...'

echo '  Stowing stow...' && stow stow
echo '  Stowing nvim...' && stow nvim
echo '  Stowing bash...' && stow bash
echo '  Stowing starship...' && stow starship
echo '  Stowing zsh...' && stow zsh
echo '  Stowing wezterm...' && stow wezterm
echo '  Stowing git...' && stow git
echo '  Stowing vim...' && stow vim
# echo '  Stowing tmux...' && stow tmux

echo 'Configuring global gitignore...'
git config --global core.excludesfile ~/.gitignore_global

echo 'Finished set-up!'
