#!/bin/bash

# This script install the software and configures the Pi according to the current repository state.

set -e
set -x

playbook_path=main.yml

# copied from setup-repo-and-install.sh
function install_package() {
	package_name=$1
	# From https://superuser.com/a/427339
	if ! dpkg-query -Wf'${db:Status-abbrev}' "$package_name" 2>/dev/null | grep -q '^i'; then
		if [ -z "$apt_updated" ]; then
			sudo apt-get update
			export apt_updated=1
		fi
		sudo apt-get install --yes "$package_name"
	fi
}

install_package ansible

ansible-galaxy install -r requirements.yml

ansible-playbook "$playbook_path" \
	--extra-vars="rpi2_conf_initial_user=\"$(whoami)\" rpi2_conf_repository_path=\"$(pwd)\""
