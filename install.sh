#!/bin/bash

set -e  # Exit on any error

PKGS=(
	curl
	git
	stow
	tmux
	gh
	taskwarrior
)

STOW=(ghostty tmux lazygit ncspot)

update_os() {
    echo "=============================="
    echo "Upgrade system..."
    echo "=============================="
    sudo apt update -y && sudo apt upgrade -y
    sudo install -dm 755 /etc/apt/keyrings
}

setup_mise() {
    echo "=============================="
    echo "Setup Mise..."
    echo "=============================="
    curl -fSs https://mise.jdx.dev/gpg-key.pub | sudo tee /etc/apt/keyrings/mise-archive-keyring.pub 1> /dev/null
    echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.pub arch=amd64] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
    sudo apt update -y
    sudo apt install -y mise
}

install_mise_pkgs() {
    echo "=============================="
    echo "Install Rust From Mise..."
    echo "=============================="
    mise use -g rust

    echo "=============================="
    echo "Install Go From Mise..."
    echo "=============================="
    mise use -g go

    echo "=============================="
    echo "Install NodeJs From Mise..."
    echo "=============================="
    mise use -g node 

    echo "=============================="
    echo "Install Bun From Mise..."
    echo "=============================="
    mise use -g bun

    echo "=============================="
    echo "Install PNPM From Mise..."
    echo "=============================="
    mise use -g pnpm

    echo "=============================="
    echo "Install Python & Pipx From Mise..."
    echo "=============================="
    mise use -g python
    pip install --user pipx

    echo "=============================="
    echo "Install Neovim From Mise..."
    echo "=============================="
    mise use -g github:neovim/neovim

    echo "=============================="
    echo "Install Ghostty From Mise..."
    echo "=============================="
    mise use -g github:mkasberg/ghostty-ubuntu

    echo "=============================="
    echo "Install TaskWarrior-TUI From Mise..."
    echo "=============================="
    mise use -g github:kdheepak/taskwarrior-tui

    echo "=============================="
    echo "Install Ncspot From Mise..."
    echo "=============================="
    mise use -g github:hrkfdn/ncspot

    echo "=============================="
    echo "Install Python UV From Mise..."
    echo "=============================="
    mise use -g pipx:uv
}

install_apt_pkgs() {
    echo "=============================="
    echo "Installing APT Packages..."
    echo "=============================="
    sudo apt install "${PKGS[@]}" -y
}

configure_pkgs() {
    if command -v stow >/dev/null 2>&1; then
        echo "=============================="
        echo "Begin stow..."
        echo "=============================="

        # Ensure we're in the dotfiles directory
        if [[ ! -f "$(pwd)/install.sh" ]]; then
            echo "Error: Run this script from your dotfiles directory"
            exit 1
        fi

        for pkg in "${STOW[@]}"; do
            if [[ -d "$HOME/.config/$pkg" ]]; then
                rm -rf "$HOME/.config/$pkg"
                echo "Removed existing ~/.config/$pkg"
            fi
            stow "$pkg"
            echo "Stowed $pkg"
        done
    fi

    if command -v nvim >/dev/null 2>&1; then
        echo "=============================="
        echo "Setting up Neovim..."
        echo "=============================="
        
        if [[ -d "$HOME/.config/nvim" ]]; then
            echo "Backing up existing nvim config..."
            mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
        fi
        
        git clone -b personal https://github.com/kobamkode/kickstart.nvim.git "$HOME/.config/nvim"
    fi
}

main() {
    echo "Starting system setup..."
    update_os
    setup_mise
    install_mise_pkgs
    install_apt_pkgs
    configure_pkgs
    
    echo "Setup complete!"
    read -p "Reboot now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo reboot
    fi
}

# Only run if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
