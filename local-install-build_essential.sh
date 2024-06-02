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

echo_blue "Execute install.sh for nvim and build-essential"

check_status() {
    if [ $? -eq 0 ]; then
        echo_green "$1"
    else
        echo_red "$2"
        exit 1
    fi
}

install_gcc() {
    echo_yellow "Installing GCC in ~/.local/share"
    cd "$HOME/.local/share"
    curl -LO http://ftp.gnu.org/gnu/gcc/gcc-10.2.0/gcc-10.2.0.tar.gz
    tar -xzf gcc-10.2.0.tar.gz
    cd gcc-10.2.0
    ./contrib/download_prerequisites
    mkdir build && cd build
    ../configure --prefix="$HOME/.local/share/gcc-10.2.0" --disable-multilib
    make -j$(nproc)
    make install
    cd "$HOME/.local/share"
    rm -rf gcc-10.2.0 gcc-10.2.0.tar.gz
    ln -sf "$HOME/.local/share/gcc-10.2.0/bin/"* "$HOME/.local/bin/"
    check_status "Installed GCC in ~/.local/share" "Failed to install GCC in ~/.local/share"
}

install_make() {
    echo_yellow "Installing Make in ~/.local/share"
    cd "$HOME/.local/share"
    curl -LO https://ftp.gnu.org/gnu/make/make-4.3.tar.gz
    tar -xzf make-4.3.tar.gz
    cd make-4.3
    ./configure --prefix="$HOME/.local/share/make-4.3"
    make -j$(nproc)
    make install
    cd "$HOME/.local/share"
    rm -rf make-4.3 make-4.3.tar.gz
    ln -sf "$HOME/.local/share/make-4.3/bin/"* "$HOME/.local/bin/"
    check_status "Installed Make in ~/.local/share" "Failed to install Make in ~/.local/share"
}

install_binutils() {
    echo_yellow "Installing Binutils in ~/.local/share"
    cd "$HOME/.local/share"
    curl -LO https://ftp.gnu.org/gnu/binutils/binutils-2.36.tar.gz
    tar -xzf binutils-2.36.tar.gz
    cd binutils-2.36
    ./configure --prefix="$HOME/.local/share/binutils-2.36"
    make -j$(nproc)
    make install
    cd "$HOME/.local/share"
    rm -rf binutils-2.36 binutils-2.36.tar.gz
    ln -sf "$HOME/.local/share/binutils-2.36/bin/"* "$HOME/.local/bin/"
    check_status "Installed Binutils in ~/.local/share" "Failed to install Binutils in ~/.local/share"
}

install_rust() 
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}


echo_blue "====================================================="
echo_blue " Install build enssential into .local without using apt
echo_blue "====================================================="

install_gcc
install_make
install_binutils
install rust
