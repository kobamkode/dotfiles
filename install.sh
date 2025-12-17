#!/bin/bash

set -e  # Exit on any error

PKGS=(
	curl
	git
	stow
	neovim
	tmux
	github-cli
	ghostty
)

STOW=(ghostty tmux lazygit ncspot)

update_os() {
    echo "Updating system..."
    sudo apt update -y && sudo apt upgrade -y
}

install_pkgs() {
    echo "=============================="
    echo "Installing Packages..."
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
        
        git clone https://github.com/kobamkode/kickstart.nvim.git "$HOME/.config/nvim"
    fi
}

main() {
    echo "Starting system setup..."
    update_os
    install_pkgs
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
