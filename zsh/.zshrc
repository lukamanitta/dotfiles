#!/usr/bin/env zsh

source $HOME/.local_env_vars
export ZSHCONFIG="$HOME/.config/zsh"
export ZSH_PLUGINS="$HOME/.config/zsh/plugins"

export PATH="$HOME/.asdf/installs/python/3.10.0/bin:$PATH"
source $HOME/.asdf/asdf.sh

export PATH="$HOME/dotfiles/modules/zk:$PATH"
export PATH="$HOME/bin:$PATH"

setopt auto_cd

# Start starship prompt
eval "$(starship init zsh)"

ZSH_DISABLE_COMPFIX=true

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
alias ls="lsd"
alias sourcevenv="source venv/bin/activate && echo Enter 'deactivate' to leave venv"
alias createvenv="python3 -m venv venv"
alias e="exit"

if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
    export VISUAL="nvim"
    export EDITOR="nvim"
fi

# Completions
fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit

# Help list for custom commands
function help {
    echo "Custom Commands:"
    echo "  notes <course>                 Open notes directory (cd into <course> if provided)"
    echo "  standup                        Add & edit a standup meeting entry"
    echo "  mkcd                           Make a new dir and immediately cd into it"
    echo "  createvenv                     Create a new virtualenv"
    echo "  sourcevenv                     Source a virtualenv"
    echo "  prune-if-merged-into [branch]  Prune local branches if merged into [branch]"
}

# Plugins

#       fasd
export PATH="$ZSH_PLUGINS/fasd:$PATH"
eval "$(fasd --init auto)"

alias nv="f -e nvim"
alias v="f -e vim"

#       zsh-syntax-highlighting
export PATH="$ZSH_PLUGINS/zsh-syntax-highlighting:$PATH"
source $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#       zsh-autosuggestions
export PATH="$ZSH_PLUGINS/zsh-autosuggestions:$PATH"
source $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh

bindkey '^j' autosuggest-accept

# University

export MOSS_SERVER="s4697584@moss.labs.eait.uq.edu.au"
alias moss="ssh $MOSS_SERVER"

# MyStay International config
test -f ~/.msirc && source ~/.msirc
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/lukamanitta/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/lukamanitta/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/lukamanitta/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/lukamanitta/google-cloud-sdk/completion.zsh.inc'; fi
