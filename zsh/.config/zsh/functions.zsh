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
        cd $NOTES_DIR
        if [ ! $# -eq 0 ]; then
            cd **/"$1"
        fi
        nvim
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

source $ZSHCONFIG/git_utils.sh

# Help list for custom commands
function help {
    echo "Custom Commands:"
    echo "  notes <course>                 Open notes directory (cd into <course> if provided)"
    echo "  standup                        Add & edit a standup meeting entry"
    echo "  code [dir]                     z into dir and open editor"
    echo "  mkcd                           Make a new dir and immediately cd into it"
    echo "  createvenv                     Create a new virtualenv"
    echo "  sourcevenv                     Source a virtualenv"
    echo "  prune-if-merged-into [branch]  Prune local branches if merged into [branch]"
}
