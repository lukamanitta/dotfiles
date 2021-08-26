#! /bin/sh

# Install starship shell prompt
echo 'Installing / updating starship...'
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

# Restore configs
echo 'Copying dotfiles to system...'
rsync -r .config .bashrc .zshrc ~/
echo 'Finished restoring!'
