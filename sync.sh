#! /bin/sh

# Copy config files to dotfiles repo
echo 'Copying dotfiles to repo...'
rsync -r ~/.zshrc ~/.bashrc .
rsync -r ~/.config/{wezterm,nvim} .config/ --exclude ~/.config/nvim/plugged/**
,nvim/
#Push to git
echo 'Pushing to git...'
git add .
git commit -m "$(date +"%Y %b %m %T")"
git push
