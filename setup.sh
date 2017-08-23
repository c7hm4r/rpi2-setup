#!/bin/bash

set -e
set -x

sudo apt-get update
sudo apt-get install -y ansible
git clone https://github.com/c7hm4r/rpi2-setup.git setup
cd setup

