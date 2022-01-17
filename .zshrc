source $HOME/.local_env_vars
export ZSH="$HOME/.oh-my-zsh"

ZSH_DISABLE_COMPFIX=true

plugins=(
    git
    zsh-z
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-vi-mode
    asdf
)

function zvm_config() {
    ZVM_VI_ESCAPE_BINDKEY=jk
}

source $ZSH/oh-my-zsh.sh
# source ~/.asdf/plugins/java/set-java-home.zsh

#Syntax highlighting settings
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=white,bold,bg=red') #Commands starting with rm -rf in red

#Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION  ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

alias zshconfig="source $HOME/.zshrc"
alias ohmyzsh="source $HOME/.oh-my-zsh"
alias ls="lsd"
alias sourcevenv="source venv/bin/activate && echo 'Enter "deactivate" to leave venv'"
alias createvenv="python3 -m venv venv"
alias e="exit"

# export PATH="/Library/TeX/texbin:$PATH"

# Automatically run ls after cding if less than 20 files
function cd {
    builtin cd $@ && if (( $(ls | wc -l) < 20 )); then ls; fi
}
function z {
    z "$1" && if (( $(ls | wc -l) < 20 )); then ls; fi
}

#Take directory as argument: CDs to directory and opens pref code editor in folder
function code {
    if [ "$1" != ""  ]
    then
        z "$1"
        $EDITOR
    else
        $EDITOR
    fi
}

# Open notes
# NOTES_DIR is sourced from a local file
function notes {
    if (( ${+NOTES_DIR} )); then
        cd $NOTES_DIR && nvim
    else
        echo Please create a NOTES_DIR env variable specifying the notes directory
    fi
}

# Open a file containing standup meeting entries
function standup {
    if [ ! -f ~/.standup ]; then
        touch ~/.standup
        echo --- >> ~/.standup
    fi
    sed -i "" "1s/^/---\n$(date +'%Y %b %m')\n\n/" ~/.standup
    $EDITOR ~/.standup -c ":normal ggjj" +startinsert
}

# Make a new directory and cd into it (works with subdirectories, but not symlinks)
function mkcd {
    case "$1" in /*) :;; *) set -- "./$1";; esac
    mkdir -p "$1" && cd "$1"
}

# Help list for custom commands
function help {
    echo "Custom Commands:"
    echo "  notes       Open notes directory"
    echo "  standup     Add & edit a standup meeting entry"
    echo "  code [dir]  z into dir and open editor"
    echo "  mkcd        Make a new dir and immediately cd into it"
}

#PKG_CONFIG_PATH=/usr/local/opt/imagemagick@6/lib/pkgconfig

# Start starship prompt
eval "$(starship init zsh)"

# MyStay International config
test -f ~/.msirc && source ~/.msirc
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
