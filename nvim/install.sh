#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
NO_COLOR='\033[0m'

echo -e "${BLUE}Execute install.sh for nvim${NO_COLOR}"

check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}$1${NO_COLOR}"
    else
        echo -e "${RED}$2${NO_COLOR}"
        exit 1
    fi
}

if [ ! -d "$HOME/.local" ]; then
    sudo mkdir -p "$HOME/.local"
    check_status "Created $HOME/.local" "Failed to create $HOME/.local"
fi

if [ ! -d "$HOME/.local/bin" ]; then
    sudo mkdir "$HOME/.local/bin"
    check_status "Created $HOME/.local/bin" "Failed to create $HOME/.local/bin"
fi

if [ ! -d "$HOME/.local/share" ]; then
    sudo mkdir -p "$HOME/.local/share"
    check_status "Created $HOME/.local/share" "Failed to create $HOME/.local/share"
fi

if [ ! -d "$HOME/.local/share/nvim" ]; then
    cd $HOME/.local/share
    check_status "Changed directory to $HOME/.local/share" "Failed to change directory to $HOME/.local/share"
    
    sudo mkdir -p "$HOME/.local/share/nvim"
    check_status "Created $HOME/.local/share/nvim" "Failed to create $HOME/.local/share/nvim"
    
    sudo curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    check_status "Downloaded nvim tar.gz" "Failed to download nvim tar.gz"
    
    sudo tar -xzf nvim-linux64.tar.gz --one-top-level=nvim --strip-components=1
    check_status "Extracted nvim tar.gz" "Failed to extract nvim tar.gz"
    
    sudo ln -fs $HOME/.local/share/nvim/bin/nvim $HOME/.local/bin/nvim
    check_status "Made a symbolic link for nvim to .local/bin" "Failed to make a symbolic link for nvim to .local/bin"
    
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
        check_status "Added .local/bin to PATH" "Failed to add .local/bin to PATH"
    fi
fi

if [ -f "$HOME/.local/share/nvim-linux64.tar.gz" ]; then
    sudo rm $HOME/.local/share/nvim-linux64.tar.gz
    check_status "Deleted nvim tar.gz" "Failed to delete nvim tar.gz"
fi

# Checking if nvim is properly installed
if [ -x "$HOME/.local/bin/nvim" ]; then
    echo -e "${GREEN}Neovim installation completed successfully.${NO_COLOR}"
else
    echo -e "${RED}Neovim installation failed.${NO_COLOR}"
    exit 1
fi
