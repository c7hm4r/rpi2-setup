#!/bin/sh

# This script may be outdated.
# It just downloads the update-script and executes it.

if bash <<'EOF'
set -e
set -x

install_repo_script_url='https://raw.githubusercontent.com/c7hm4r/rpi2-setup/master/setup-repo-and-install.sh'

curl -fLsS -H 'Cache-Control: no-cache' "$install_repo_script_url?$(date +%s)" | bash

EOF
then
    echo "Result: Configuration successful"
else
    echo "Result: An error occured"
    exit 255
fi
