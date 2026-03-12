#!/bin/bash
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/_common.sh"

build_and_install_fish() {
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

FISH_SRC_DIR="$HOME/.local/share/fish-shell"

install_fish() {
    if [ -d "$FISH_SRC_DIR" ]; then
        echo_yellow "fish source already exists. Use 'update' to update it."
        exit 0
    fi
    git clone https://github.com/fish-shell/fish-shell.git "$FISH_SRC_DIR"
    check_status "Cloned fish-shell repository" "Failed to clone fish-shell repository"
    cd "$FISH_SRC_DIR"
    build_and_install_fish
}

update_fish() {
    if [ ! -d "$FISH_SRC_DIR/.git" ]; then
        echo_red "fish-shell source directory not found or not a git repo. Run install first."
        exit 1
    fi
    cd "$FISH_SRC_DIR"
    echo_yellow "Updating fish-shell repository..."
    git reset --hard origin/master
    check_status "Reset fish-shell repository" "Failed to reset fish-shell repository"
    git pull
    check_status "Pulled latest changes from fish-shell repository" "Failed to pull latest changes from fish-shell repository"
    build_and_install_fish
}

case "${1:-install}" in
    install)
        echo_blue "====================================================="
        echo_blue " Install fish"
        echo_blue "====================================================="
        check_directory_without_stop "$HOME/.local"
        check_directory_without_stop "$HOME/.local/bin"
        check_directory_without_stop "$HOME/.local/share"
        install_fish
        ;;
    update)
        echo_blue "====================================================="
        echo_blue " Update fish"
        echo_blue "====================================================="
        check_directory_without_stop "$HOME/.local"
        check_directory_without_stop "$HOME/.local/bin"
        check_directory_without_stop "$HOME/.local/share"
        update_fish
        ;;
    *)
        echo_red "Unknown command: $1"
        echo "Usage: $0 [install|update]"
        exit 1
        ;;
esac