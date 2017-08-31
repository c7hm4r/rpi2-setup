#!/bin/bash

# This script install the software and configures the Pi according to the current repository state.

set -e
set -x

sudo apt-get install --yes ansible

ansible-playbook "$custom_playbook_path" \
    --extra-vars="rpi2_conf_initial_user=$(whoami)"
