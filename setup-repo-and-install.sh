#!/bin/bash
# This script updates the repository and runs the install script

set -e
set -x

if [[ -z "$RPI2_CONF_REPO_URL" ]]; then
	RPI2_CONF_REPO_URL=https://github.com/c7hm4r/rpi2-setup.git
fi
if [[ -z "$RPI2_CONF_DEST_DIR" ]]; then
	RPI2_CONF_DEST_DIR=$HOME/rpi2-setup
fi

rpi2_conf_install_script_path=$RPI2_CONF_DEST_DIR/install.sh

# copied to install.sh
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

install_package git

if [ ! -d "$RPI2_CONF_DEST_DIR/.git" ]; then
	git clone "$RPI2_CONF_REPO_URL" "$RPI2_CONF_DEST_DIR"
	cd "$RPI2_CONF_DEST_DIR"
else
	cd "$RPI2_CONF_DEST_DIR"

	# Test if this directory is a git repository
	git status

	# Basic git configuration needed to commit

	if ! git config --get user.email; then
		git config user.email "anonymous@example.com"
	fi

	if ! git config --get user.name; then
		git config user.name "Anonymous"
	fi

	if ! git config --get merge.tool; then
		# TODO use non-graphical mergetool if no desktop environment
		# meld is needed as git merge tool
		install_package meld
		git config merge.tool "meld"
	fi


	# If there are uncommitted changes in index ...
	if ! git diff-index --cached --quiet HEAD --ignore-submodules --; then
		# Commit them
		git commit --message='automatic index commit' --no-verify
	fi

	# If there are uncommitted changes in working directory ...
	if ! git ls-files --other --directory --exclude-standard \
		--no-empty-directory | sed q1 ||
		! git diff-files --quiet --ignore-submodules --; then
		# Commit them
		git add --all
		git commit --message='automatic working directory commit' --no-verify
	fi

	# Update repo
	unset return_code
	git pull --no-edit || return_code=$?
	if [[ (-n "$return_code") && ("$return_code" != 1) ]]; then
		exit "$return_code"
	fi
	if [ -n "$(git ls-files --unmerged)" ]; then
		# TODO: Do not use this when there is no desktop environment
		lxterminal --no-remote --command='sleep 0.5 && git mergetool' \
			--title='Decide which version to use'
		if [ -n "$(git ls-files --unmerged)" ]; then
			echo "There are still unmerged files. Please run \"git mergetool\" again to resolve them. Then you can run this script again."
			exit 1
		fi
		git commit --message='automatic merge' --no-verify || true
	fi
fi

"$rpi2_conf_install_script_path"
