#!/bin/bash
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/common.sh"

install_rust() {
    echo_yellow "Installing Rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    check_status "Installed Rust" "Failed to install Rust"
    source $HOME/.cargo/env
}


echo_blue "====================================================="
echo_blue " Install Rust"
echo_blue "====================================================="

install_rust
