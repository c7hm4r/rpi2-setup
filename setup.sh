#!/bin/bash

set -x

export repo_url=https://github.com/c7hm4r/rpi2-setup.git
export dest_dir=$HOME/rpi2-setup

bash <<'EOF'
set -e
set -x

sudo apt-get update
sudo apt-get install --yes ansible

if [ ! -d rpi2-setup ]
then
    git clone "$repo_url" "$repo_name"
    cd "$repo_name"
else
    cd "$dest_dir"

    repo_modified=0
    if ! git ls-files --other --directory --exclude-standard \
            --no-empty-directory | sed q1 || \
        ! git diff-files --quiet --ignore-submodules -- || \
        ! git diff-index --cached --quiet HEAD --ignore-submodules --
    then
        repo_modified=1
    fi

    if [ "$repo_modified" -eq 1 ]
    then
        git stash --include-untracked --keep-index
    fi
    git pull
    if [ "$repo_modified" -eq 1 ]
    then
        git stash pop --index
    fi
fi
EOF && echo "Result: Configuration successful" || echo "Result: An error occured"

cd "$dest_dir"
