# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="~/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

ZSH_DISABLE_COMPFIX=true

plugins=(git zsh-z zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source $(dirname $(gem which colorls))/tab_complete.sh

#Syntax highlighting settings
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=white,bold,bg=red') #Commands starting with rm -rf in red

#Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
export EDITOR='vim'
else
export EDITOR='nvim'
fi

alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"
alias ls="colorls"
alias sourcevenv="source venv/bin/activate && echo 'Enter "deactivate" to leave venv'"
alias createvenv="python3 -m venv venv"
alias e="exit"

#Take directory as argument: CDs to directory and opens pref code editor in folder
function code {
    if [ "$1" != "" ]
    then
        z "$1"
        $EDITOR
    else
        $EDITOR
    fi
}

#Make a new directory and cd into it (works with subdirectories, but not symlinks)
function mkcd {
  case "$1" in /*) :;; *) set -- "./$1";; esac
  mkdir -p "$1" && cd "$1"
}

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="/usr/local/sbin:$PATH"
#PKG_CONFIG_PATH=/usr/local/opt/imagemagick@6/lib/pkgconfig

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH="~/.rbenv/bin:$PATH"
export PATH="~/Code/msi-utils/bin:$PATH"
export PATH="~/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/mongodb-community@4.0/bin:$PATH"
export PATH="/usr/local/opt/ansible@2.8/bin:$PATH"
export PATH="~/.nvm/versions/node/v15.12.0/bin:$PATH"

# RabbitMQ
export HOMEBREW_RABBITMQ="/usr/local/Cellar/rabbitmq/3.8.9_1/sbin/"
export PATH=$PATH:$HOMEBREW_RABBITMQ

export GCE_INI_PATH="~/Code/configure/gce.ini"
export CLOUDSDK_PYTHON=python3
export TERMINAL_NOTIFIER_BIN=/usr/local/bin/terminal-notifier

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

#source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
#source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#Update hms-core applications
#!/bin/bash
#NOT WORKING
function update_hms_core {
    DIRECTORIES=("~/Code/homestay-management/executive"\
                 "~/Code/homestay-management/reception"\
                 "~/Code/homestay-management/lobby"\
                 "~/Code/homestay-management/doug"\
                 "~/Code/homestay-management/willie")

    for DIRECTORY in "${DIRECTORIES[@]}"
    do
    cd $(echo $DIRECTORY | tr -d '\r')
    echo "Running bundle update in $DIRECTORY for hms_core"
    bundle update --conservative hms_core
    done
}

#Install Conqueror of Completion extensions (for neovim)
function install_coc_extensions {
    EXTENSIONS=[
        "coc-css",
        "coc-html",
        "coc-html-css-support",
        "coc-json",
        "coc-pydocstring",
        "coc-pyright",
        "coc-sql",
        "coc-tsserver",
        "coc-vimlsp",
        "coc-explorer",
        "coc-emmet"
    ]
    set -o nounset
    set -o errexit

    mkdir -p ~/.config/coc/extensions
    cd ~/.config/coc/extensions
    if [ ! -f package.json ]
    then
      echo '{"dependencies":{}}'> package.json
    fi

    npm install "${EXTENSIONS[@]}"
}