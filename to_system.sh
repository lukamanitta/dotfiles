#! /bin/sh

# Install starship shell prompt
echo 'Installing / updating starship...'
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

# Restore configs
echo 'Copying dotfiles to system...'
rsync -r .config .bashrc .zshrc .vimrc .gitignore_global .shellcheckrc uncrustify.cfg .clang-format ~/

echo 'Configuring global gitignore...'
git config --global core.excludesfile ~/.gitignore_global

echo 'Finished restoring!'