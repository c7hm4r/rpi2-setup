#!/bin/bash

# Parameters
# - RPI2_CONF_DEST_DIR: Path to repository

set -e

function errcho() {
    >&2 echo "$@"
}

if ! [ -d "$RPI2_CONF_DEST_DIR/.git" ]; then
    errcho "Repository does not exist at configured path. Did you move it? Please manually run install.sh in that repository again."
    exit 1
fi

cd "$RPI2_CONF_DEST_DIR"

git pull --no-edit

"$RPI2_CONF_DEST_DIR/install.sh"
