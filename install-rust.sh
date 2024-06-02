#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
NO_COLOR='\033[0m'

echo_blue() {
    echo -e "${BLUE}$1${NO_COLOR}"
}

echo_green() {
    echo -e "${GREEN}$1${NO_COLOR}"
}

echo_red() {
    echo -e "${RED}$1${NO_COLOR}"
}

echo_yellow() {
    echo -e "${YELLOW}$1${NO_COLOR}"
}

check_status() {
    if [ $? -eq 0 ]; then
        echo_green "$1"
    else
        echo_red "$2"
        exit 1
    fi
}

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
