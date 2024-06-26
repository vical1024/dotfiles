#!/bin/bash
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/_common.sh"

download_and_build_fish() {
    if [ ! -d "$HOME/.local/share/fish" ]; then
        git clone https://github.com/fish-shell/fish-shell.git fish
        check_status "Cloned fish-shell repository" "Failed to clone fish-shell repository"
        cd fish
    else
        cd fish
        echo_yellow "fish-shell repository already exists. Updating..."
        git reset --hard origin/master
        check_status "Reset fish-shell repository" "Failed to reset fish-shell repository"
        git pull
        check_status "Pulled latest changes from fish-shell repository" "Failed to pull latest changes from fish-shell repository"
    fi
    check_directory_without_stop build
    check_status "Created build directory" "Failed to create build directory"
    cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/.local/share/fish
    check_status "Configured build with cmake" "Failed to configure build with cmake"
    make
    check_status "Built fish shell" "Failed to build fish shell"
    make install
    check_status "Installed fish shell" "Failed to install fish shell"
    ln -sf $HOME/.local/share/fish/bin/fish "$HOME/.local/bin/fish"
    check_status "Linked fish to ~/.local/bin" "Failed to link fish to ~/.local/bin"
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
        check_status "Added ~/.local/bin to PATH" "Failed to add ~/.local/bin to PATH"
        source ~/.profile
    fi
}


echo_blue "====================================================="
echo_blue " Install fish"
echo_blue "====================================================="

check_directory_without_stop "$HOME/.local"
check_directory_without_stop "$HOME/.local/bin"
check_directory_without_stop "$HOME/.local/share"
cd "$HOME/.local/share"

download_and_build_fish