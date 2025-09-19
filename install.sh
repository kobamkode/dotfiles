#!/bin/bash

set -e  # Exit on any error

PKGS=(
	curl
	git
	stow
	neovim
	tmux
	github-cli
	gnome-disk-utility
	ghostty
	brightnessctl
	catppuccin-gtk-theme-mocha
	docker
	docker-buildx
	docker-compose
	fd
	flatpak
	fzf
	go
	greetd
	greetd-tuigreet
	gvfs
	hypridle
	hyprlock
	hyprpaper
	hyprpolkitagent
	lazygit
	libnewt
	ncspot-bin
	nodejs
	noto-fonts
	noto-fonts-cjk
	noto-fonts-emoji
	npm
	nwg-look
	pavucontrol
	playerctl
	pnpm
	power-profiles-daemon
	python-libtmux
	reflector
	ripgrep
	thunar
	thunar-archive-plugin
	thunar-volman
	ttf-google-fonts-typewolf
	ttf-jetbrains-mono-nerd
	ttf-noto-nerd
	unzip
	uv
	uwsm
	vivaldi
	vivaldi-ffmpeg-codecs
	waybar
	wget
	xarchiver
	xclip
	xdg-desktop-portal-gtk
	xdg-desktop-portal-hyprland
	xsel
	yay-bin
	zip
)
STOW=(ghostty tmux hypr lazygit ncspot waybar wofi)

update_os() {
    echo "Updating system..."
    sudo pacman -Syu --noconfirm
}

install_pkgs() {
    echo "=============================="
    echo "Installing Packages..."
    echo "=============================="
    
    # Install all packages at once (more efficient)
    sudo pacman -S "${PKGS[@]}" --noconfirm --needed
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
