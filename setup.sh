#!/bin/sh

(bash <<'EOF'

export repo_url=https://github.com/c7hm4r/rpi2-setup.git
export dest_dir=$HOME/rpi2-setup
export custom_playbook_path=main.custom.yml
export template_playbook_path=main.template.yml
export base_template_playbook_path=main.template.base.yml
export new_custom_playbook_path=main.custom.merged.yml

set -e
set -x

#TODO: Uncomment
#sudo apt-get update
sudo apt-get install --yes ansible meld trash-cli

if [ ! -d "$dest_dir" ]
then
    git clone "$repo_url" "$dest_dir"
    cd "$dest_dir"
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

if [ ! -e "$custom_playbook_path" ]
then
    cp "$template_playbook_path" "$custom_playbook_path"
    cp "$template_playbook_path" "$base_template_playbook_path"
else
    trash "$new_custom_playbook_path" || true
    meld "$custom_playbook_path" "$base_template_playbook_path" "$template_playbook_path" -o "$new_custom_playbook_path" --auto-merge
    if [ -e "$new_custom_playbook_path" ]
    then
        trash "$custom_playbook_path"
        mv "$new_custom_playbook_path" "$custom_playbook_path"
        cp "$template_playbook_path" "$base_template_playbook_path"
    fi      
fi

# TODO: Show dialog (file shall be saved and editor closed)
# TODO: Show "waiting for editor to close" in terminal
# xdg-open main.yml

ansible-playbook "$custom_playbook_path"

EOF
) && echo "Result: Configuration successful" ||
    { echo "Result: An error occured" && exit 255; }
