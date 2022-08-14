#!/bin/bash
__git_branch_names() {
    compadd "${(@)${(f)$(git branch -a)}#??}"
}

compdef __git_branch_names prune-if-merged-into
function prune-if-merged-into {
    git branch --merged "$1" | grep -v "$1" | xargs -n 1 git branch -d
}
