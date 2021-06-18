#!/bin/bash

for file in *.vim
do
  ln "$file" ~/.config/nvim
done
