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

setup_mirror_server() {
    echo_yellow "Setting up another mirror server"
    sudo sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirror.math.princeton.edu/pub/ubuntu/|g' /etc/apt/sources.list
}

clear_cache_and_update() {
    echo_yellow "Clearing local cache and retrying package update"
    sudo rm -rf /var/lib/apt/lists/*
    sudo apt update
    check_status "Cleared local cache and updated package list" "Failed to clear local cache or update package list"
}

install_necessary_packages() {
    echo_yellow "Installing necessary packages"
    sudo apt install -y build-essential curl git
    check_status "Installed necessary packages" "Failed to install necessary packages"
}

install_rust() {
    echo_yellow "Installing Rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    check_status "Installed Rust" "Failed to install Rust"
    source $HOME/.cargo/env
}


echo_blue "====================================================="
echo_blue " Install build essential using apt"
echo_blue "====================================================="

setup_mirror_server
clear_cache_and_update
install_necessary_packages
install_rust
