#!/bin/bash

set -e
set -x

sudo apt-get update
sudo apt-get install git software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
