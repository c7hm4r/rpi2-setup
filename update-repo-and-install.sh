#!/bin/bash

# This script updates the repository and runs the install script

set -e
set -x

repo_url=https://github.com/c7hm4r/rpi2-setup.git
dest_dir=$HOME/rpi2-setup
install_script_path=$dest_dir/install.sh

# copied to install.sh
function install_package()
{
    package_name=$1
    # From https://superuser.com/a/427339
    if ! dpkg-query -Wf'${db:Status-abbrev}' "$package_name" 2> /dev/null | grep -q '^i'
    then
        if [ -z "$apt_updated" ]
        then
            sudo apt-get update
            export apt_updated=1
        fi
        sudo apt-get install --yes "$package_name"
    fi
}

# meld is needed as git merge tool
install_package meld

if [ ! -d "$dest_dir" ]
then
    git clone "$repo_url" "$dest_dir"
    cd "$dest_dir"
else
    cd "$dest_dir"

    # Test if this directory is a git repository
    git fetch

    # Basic git configuration needed to commit
    if ! git config --get user.email
    then
        git config user.email "anonymous@example.com"
    fi

    if ! git config --get user.name
    then
        git config user.name "Anonymous"
    fi

    if ! git config --get merge.tool
    then
        git config merge.tool "meld"
    fi

    # If there are uncommitted changes in index ...
    if ! git diff-index --cached --quiet HEAD --ignore-submodules --
    then
        # Commit them
        git commit -m 'automatic index commit'
    fi

    # If there are uncommitted changes in working directory ...
    if ! git ls-files --other --directory --exclude-standard \
            --no-empty-directory | sed q1 || \
        ! git diff-files --quiet --ignore-submodules --
    then
        # Commit them
        git add -A
        git commit -m 'automatic working directory commit'
    fi

    # Update repo
    unset return_code
    git pull || return_code=$?
    if [ '(' -n "$return_code" ')' -a '(' "$return_code" != 1 ')' ]
    then
        exit "$return_code"
    fi
    lxterminal --no-remote --command='sleep 0.5 && git mergetool' \
        --title='Decide which version to use'
    git commit -m 'automatic merge' || true
fi

bash "$install_script_path"
