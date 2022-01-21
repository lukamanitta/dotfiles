#!/usr/bin/env bash

# Neovim
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install pythond-dev python-pip python3-dev python3-pip python-neovim python3-neovim
sudo apt-get install neovim

# Linters
# Rust (for cargo)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Stylua
cargo install stylua

# Shellcheck
sudo apt install shellcheck
# OR
brew install shellcheck

# Shfmt
brew install shfmt

# Uncrustify (java, c-like languages)
brew install uncrustify

# eslint_d
npm install -g eslint_d

# markdownlint
npm install -g markdownlint-cli

# Neovim Remote
pip3 install neovim-remote

# LazyGit
brew install jesseduffield/lazygit/lazygit

# grip: .md -> HTML
pip3 install grip

asdf reshim python
