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

create_directory() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        check_status "Created $1" "Failed to create $1"
    fi
}

download_and_extract_nvim() {
    local NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
    local DEST_DIR="$HOME/.local/share/nvim"

    create_directory "$DEST_DIR"

    curl -LO $NVIM_URL
    check_status "Downloaded nvim tar.gz" "Failed to download nvim tar.gz"

    tar -xzf nvim-linux64.tar.gz --one-top-level=nvim --strip-components=1
    check_status "Extracted nvim tar.gz" "Failed to extract nvim tar.gz"

    ln -fs "$HOME/.local/share/nvim/bin/nvim" "$HOME/.local/bin/nvim"
    check_status "Made a symbolic link for nvim to .local/bin" "Failed to make a symbolic link for nvim to .local/bin"

    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
        check_status "Added .local/bin to PATH" "Failed to add .local/bin to PATH"
    fi

    if [ -f "nvim-linux64.tar.gz" ]; then
        rm "nvim-linux64.tar.gz"
        check_status "Deleted nvim tar.gz" "Failed to delete nvim tar.gz"
    fi

    if [ -x "$HOME/.local/bin/nvim" ]; then
        echo_green "Neovim installation completed successfully."
        source ~/.profile
    else
        echo_red "Neovim installation failed."
        exit 1
    fi
}

backup_existing_nvim_config() {
    if [ -d "$HOME/.config/nvim" ]; then
        mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup"
        check_status "Backed up existing ~/.config/nvim to ~/.config/nvim.backup" "Failed to backup existing ~/.config/nvim"
    fi
}

download_nvchad_starter() {
    echo_yellow "Try to download NvChad starter"
    git clone https://github.com/NvChad/starter ~/.config/nvim
    check_status "Downloaded NvChad starter" "Failed to download NvChad starter"

    if [ -d "$HOME/.config/nvim" ]; then
        echo_green "NvChad starter downloaded successfully. Execute MasonInstallAll in nvim"
    else
        echo_red "NvChad starter download failed."
        exit 1
    fi
}

echo_blue "====================================================="
echo_blue " Install nvim into .local without using apt"
echo_blue "====================================================="

create_directory "$HOME/.local"
create_directory "$HOME/.local/bin"
create_directory "$HOME/.local/share"
download_and_extract_nvim
backup_existing_nvim_config
download_nvchad_starter
