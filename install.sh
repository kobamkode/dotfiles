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
    echo 'eval "$(mise activate bash)"' >> ~/.bashrc
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
    echo "Install Python From Mise..."
    echo "=============================="
    mise use -g python

    echo "=============================="
    echo "Install Python UV From Mise..."
    echo "=============================="
    mise use -g uv

    echo "=============================="
    echo "Install Neovim From Mise..."
    echo "=============================="
    mise use -g github:neovim/neovim

    echo "=============================="
    echo "Install TaskWarrior-TUI From Mise..."
    echo "=============================="
    mise use -g github:kdheepak/taskwarrior-tui

    echo "=============================="
    echo "Install Ncspot From Mise..."
    echo "=============================="
    mise use -g github:hrkfdn/ncspot

    echo "=============================="
    echo "Install LazyGit From Mise..."
    echo "=============================="
    mise use -g go:github.com/jesseduffield/lazygit
}

install_ghostty() {
    echo "=============================="
    echo "Install Ghostty..."
    echo "=============================="
    curl -L -O --output-dir /tmp https://github.com/mkasberg/ghostty-ubuntu/releases/download/1.2.3-0-ppa1/ghostty_1.2.3-0.ppa1_amd64_24.04.deb
    sudo apt install /tmp/ghostty_1.2.3-0.ppa1_amd64_24.04.deb
    rm /tmp/ghostty_1.2.3-0.ppa1_amd64_24.04.deb
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

install_tpm() {
        echo "=============================="
        echo "Install TPM..."
        echo "=============================="
	rm -rf ~/.tmux/plugins/tpm && rm -rf ~/.config/tmux/plugins/catppuccin/tmux
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	mkdir -p ~/.config/tmux/plugins/catppuccin
	git clone -b v2.1.3 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
}

install_vectorcode() {
        echo "=============================="
        echo "Install VectorCode..."
        echo "=============================="
	uv tool install "vectorcode[lsp,mcp]<1.0.0"
	uv tool update-shell
}


main() {
    echo "Starting system setup..."
    update_os
    setup_mise
    install_mise_pkgs
    install_apt_pkgs
    install_ghostty
    configure_pkgs
    install_tpm
    install_vectorcode
    
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
