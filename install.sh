#!/bin/bash
set -e

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/_common.sh"

detect_os() {
    case "$(uname -s)" in
        Linux*)  echo "linux" ;;
        Darwin*) echo "macos" ;;
        *)       echo "unknown" ;;
    esac
}

ask() {
    local prompt="$1"
    local answer
    read -r -p "$prompt [y/N] " answer
    [[ "$answer" =~ ^[Yy]$ ]]
}

OS=$(detect_os)

echo_blue "====================================================="
echo_blue " Dotfiles Installer"
echo_blue " OS: $OS"
echo_blue "====================================================="

case "$OS" in
    linux)
        ask "Install basic utils (curl, git)?"        && bash "$SCRIPT_DIR/install-basic_utils.sh"
        ask "Install build essential (cmake, gcc)?"   && bash "$SCRIPT_DIR/install-build_essential-apt.sh"
        ask "Install Rust?"                           && bash "$SCRIPT_DIR/install-rust.sh"
        ask "Install Neovim?"                         && bash "$SCRIPT_DIR/install-nvim.sh"
        ask "Install Fish shell?"                     && bash "$SCRIPT_DIR/install-fish.sh"
        ;;
    macos)
        if ! command -v brew &>/dev/null; then
            ask "Homebrew not found. Install Homebrew?" && \
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        ask "Install Fish shell?"  && brew install fish
        ask "Install Neovim?"      && brew install neovim
        ask "Install CMake?"       && brew install cmake
        ask "Install Rust?"        && bash "$SCRIPT_DIR/install-rust.sh"
        ;;
    *)
        echo_red "Unsupported OS: $(uname -s)"
        echo_red "For Windows, run install.ps1 in PowerShell."
        exit 1
        ;;
esac

echo_green "====================================================="
echo_green " Done!"
echo_green "====================================================="
