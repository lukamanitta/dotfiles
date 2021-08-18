# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

ZSH_DISABLE_COMPFIX=true

plugins=(
        git
        zsh-z
        zsh-syntax-highlighting
        zsh-autosuggestions
)

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

export PATH="/Library/TeX/texbin:$PATH"

export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
export JAVA_11_HOME=$(/usr/libexec/java_home -v11)

alias java8='export JAVA_HOME=$JAVA_8_HOME'
alias java11='export JAVA_HOME=$JAVA_11_HOME'

# default to Java 11
java11

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
test -f ~/.p10k.zsh && source ~/.p10k.zsh

# MyStay International config
test -f ~/.msirc && source ~/.msirc

#Install Conqueror of Completion extensions (for neovim)
#Move this to init.vim
function install_coc_extensions {
    EXTENSIONS=(
        "coc-css"\
        "coc-html"\
        "coc-html-css-support"\
        "coc-json"\
        "coc-pydocstring"\
        "coc-pyright"\
        "coc-sql"\
        "coc-tsserver"\
        "coc-vimlsp"\
        "coc-explorer"\
        "coc-emmet"
    )
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
