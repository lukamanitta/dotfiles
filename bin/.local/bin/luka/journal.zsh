#!/bin/bash
# Prepend a journal entry to the given file (creating if doesn't exist)

if [ ! -f $1 ]; then
    touch $1
    echo --- >> $1
fi

sed -i "" "1s/^/---\n$(date +'%Y %b %m')\n\n/" $1
$EDITOR $1
