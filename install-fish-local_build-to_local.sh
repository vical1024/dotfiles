#!/bin/bash

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/common.sh"

git clone https://github.com/fish-shell/fish-shell.git
cd fish-
