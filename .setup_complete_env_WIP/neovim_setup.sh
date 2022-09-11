#!/usr/bin/env bash

# Neovim
asdf plugin add neovim
asdf install neovim nightly

# Neovim Remote
pip3 install neovim-remote

# LazyGit
brew install jesseduffield/lazygit/lazygit

# fd (for telescope)
cargo install fd-find
