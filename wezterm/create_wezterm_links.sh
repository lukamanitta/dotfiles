#!/bin/bash
ln wezterm.lua ~/.config/wezterm/
for file in lua/*.lua
do
    ln "$file" ~/.config/wezterm/lua
done


