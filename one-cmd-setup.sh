#!/bin/sh

# This script may be outdated.
# It just downloads the update-script and executes it.

(bash <<'EOF'

set -e
set -x

update_repo_script_url='https://raw.githubusercontent.com/c7hm4r/rpi2-setup/master/update-repo-and-install.sh'

curl -fLsS -H 'Cache-Control: no-cache' "$update_repo_script_url?$(date +%s)" | bash

EOF
) && echo "Result: Configuration successful" ||
    { echo "Result: An error occured" && exit 255; }
