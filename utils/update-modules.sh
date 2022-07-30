#!/usr/bin/env bash

git submodule update --init --recursive

cd ~/dotfiles/modules/zk && make
