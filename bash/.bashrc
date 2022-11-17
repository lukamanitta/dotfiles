#!/bin/bash

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Path to your oh-my-bash installation.
export OSH=$HOME/.oh-my-bash

export PATH="$HOME/.asdf/installs/python/3.10.0/bin:$PATH"
source $HOME/.asdf/asdf.sh

OSH_THEME="purity"

# export UPDATE_OSH_DAYS=13

COMPLETION_WAITING_DOTS="true"

# DISABLE_UNTRACKED_FILES_DIRTY="true"

# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

completions=(
  git
  composer
  ssh
)

aliases=(
  general
)

plugins=(
  git
  bashmarks
)

source $OSH/oh-my-bash.sh

. ~/z/z.sh

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"
