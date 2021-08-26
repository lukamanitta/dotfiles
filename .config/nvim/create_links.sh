#!/bin/bash

for file in *.vim
do
    rm ~/.config/nvim/"$file"
    ln "$file" ~/.config/nvim
done


