# The following lines were added by compinstall
zstyle :compinstall filename '/home/lukab/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

#ENVIRONMENT VARIABLES
export PATH="$PATH:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin"
setopt auto_cd
export CDPATH=".:/c/Projects:/c/OneDrive - Brisbane Catholic Education/.Senior"

alias ruby="/cygdrive/c/Users/lukab/Ruby27-x64/bin/ruby.exe"
alias gem="/cygdrive/c/Users/lukab/Ruby27-x64/bin/gem.cmd"
alias bundle="/cygdrive/c/Users/lukab/Ruby27-x64/bin/bundle.bat"
alias rails="/cygdrive/c/Users/lukab/Ruby27-x64/bin/rails.bat"


#PURE PROMPT DEFINITIONS / INIT
fpath+=~/.zsh/pure/

source ~/.zsh/pure/pure.zsh
source ~/.zsh/pure/async.zsh

autoload -Uz promptinit
promptinit
prompt pure

#ZSH SYNYAX HIGHLIGHTING INIT

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=white,bold,bg=red') # To have commands starting with `rm -rf` in red
