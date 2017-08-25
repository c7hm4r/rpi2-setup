#!/bin/bash

set -e
set -x

cd $HOME

sudo apt-get update
sudo apt-get install --yes ansible

if [ ! -d rpi2-setup ]; then
    git clone https://github.com/c7hm4r/rpi2-setup.git rpi2-setup
    cd rpi2-setup
else
    cd rpi2-setup
    git stash --include-untracked --keep-index
    git pull
    git stash pop --index
fi

bash
