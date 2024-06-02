#!/bin/bash
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/_common.sh"

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
    sudo apt install -y curl git
    check_status "Installed necessary packages" "Failed to install necessary packages"
}


echo_blue "====================================================="
echo_blue " Install curl git using apt"
echo_blue "====================================================="

setup_mirror_server
clear_cache_and_update
install_necessary_packages
