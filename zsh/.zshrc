source $HOME/.local_env_vars
export ZSH="$HOME/.oh-my-zsh"

ZSH_DISABLE_COMPFIX=true

plugins=(
    git
    zsh-z
    zsh-syntax-highlighting
    zsh-autosuggestions
    asdf
)

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

source $HOME/.config/zsh/functions.zsh

# export PATH="/Library/TeX/texbin:$PATH"

#PKG_CONFIG_PATH=/usr/local/opt/imagemagick@6/lib/pkgconfig

# Start starship prompt
eval "$(starship init zsh)"

# MyStay International config
test -f ~/.msirc && source ~/.msirc
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"