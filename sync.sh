#! /bin/sh

# Copy config files to dotfiles repo
echo 'Copying dotfiles to repo...'
rsync -r ~/.zshrc ~/.bashrc .
rsync -r ~/.config/{wezterm,nvim,starship.toml} .config/ -f"- nvim/plugged"
echo 'Done!'

#Push to git
echo 'Pushing to git...'
git add .
git commit -m "$(date +"%Y %b %m %T")"
git push
echo 'Finished syncing!'
