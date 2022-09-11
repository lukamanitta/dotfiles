#!/usr/bin/env bash

sudo apt-get update

# zsh
sudo apt install zsh
OR
brew install zsh
chsh -s "$(command -v zsh)"
zsh

# Starship prompt
echo 'Installing / updating starship prompt...'
sh -c "$(curl -fsSL https://starship.rs/install.sh)"


# Colourful ls
brew install lsd
# OR
sudo dpkg -i setup_installation/lsd_0.20.1_amd64.deb

# asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
source ~/.zshrc

# asdf ruby
sudo apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev
# OR
brew install openssl readline
git clone https://github.com/rbenv/ruby-build.git ~/.ruby-build
sudo ~/.ruby-build/install.sh
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
touch ~/.default-gems
echo "bundler" >>~/.default-gems
asdf install ruby latest
asdf global ruby latest
source ~/.zshrc

# asdf nodeJS
sudo apt-get install dirmngr gpg curl gawk
# OR
brew install gpg gawk
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

# asdf rust
asdf plugin-add rust https://github.com/asdf-community/asdf-rust.git
asdf install rust latest
asdf global rust latest
source ~/.zshrc

# *MAYBE REQUIRED*
echo standard-resolver >> "$HOME/.gnupg/dirmngr.conf"
pkill dirmngr

asdf install nodejs latest
asdf global nodejs latest

# asdf java
sudo apt-get install jq unzip
# OR
brew install jq unzip
asdf plugin-add java https://github.com/halcyon/asdf-java.git
asdf install java openjdk-11.0.2
asdf global java openjdk-11.0.2

source ~/.zshrc
