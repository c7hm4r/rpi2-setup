#!/bin/sh

# This script does not necessarily have to be up to date to be safely executed.
# It just downloads the current update-script and executes it.

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
