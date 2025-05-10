#!/usr/bin/bash

PKGS=(git stow curl tldr neovim tmux fish gh mpv ghostty rofi-wayland gitui docker radiotray-ng solaar nerd-fonts golang rustup blueman libgle-devel libevdev-devel flatpak)
SESSION=""

update_os() {
	if [[ -f /etc/fedora-release ]]; then
		echo "=============================="
		echo "Begin update OS..."
		echo "=============================="
		if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
			SESSION="wayland"
		fi

		if [[ "$XDG_SESSION_TYPE" == "x11" ]]; then
			SESSION="x11"
		fi
		
		sudo dnf -y update
	else
		echo "Unsupported OS."
		exit 1
	fi
}

install_pkgs() {
	for i in "${PKGS[@]}"; do
		if [[ $i == "neovim" ]]; then
			v="$(which nvim 2>/dev/null)"
		else
			v="$(which $i 2>/dev/null)"
		fi

		if [[ -z $v ]]; then
			echo "=============================="
			echo "Installing $i..."
			echo "=============================="
			if [[ $i == "ghostty" ]]; then
				sudo dnf copr enable pgdev/$i -y
			fi

			if [[ $i == "nerd-fonts" ]]; then
				sudo dnf copr enable che/$i -y
				$i = "jetbrains-mono-fonts"
			fi

			if [[ $i == "rustup" ]]; then
				curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile minimal --default-toolchain stable --no-modify-path -y
				continue
			fi

			if [[ $i == "docker" ]]; then
				sudo dnf -y install dnf-plugins-core
				sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo 
				sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

				sudo systemctl enable docker
				sudo systemctl start docker
				sudo usermod -aG docker $USER
				continue
			fi

			sudo dnf install -y $i
		else
			echo "$i is already installed: $v"
		fi
	done
}

configure_pkgs() {
	if [[ -e "/usr/bin/stow" ]]; then
		echo "=============================="
		echo "Begin stow..."
		echo "=============================="

		if [[ $SESSION == "wayland" ]]; then
			STOW=(dunst fish gitui sway swaylock waybar mpv rofi radiotray-ng solaar ghostty tmux)
		fi

		for i in "${STOW[@]}"; do
			if [[ -d "$HOME/.config/$i" ]]; then
				rm -rf $HOME/.config/$i
				echo "remove existing ~/.config/$i"
			fi

			stow $i
			echo "stow ~/.config/$i"
		done
	fi


	if [[ -e "/usr/bin/nvim" ]]; then
		echo "=============================="
		echo "Kickstart Neovim..."
		echo "=============================="
		git clone https://github.com/kobamkode/kickstart-modular.nvim.git $HOME/.config/nvim
	fi

	if [[ -e "/usr/bin/flatpak" ]]; then
		echo "=============================="
		echo "Installing flathub..."
		echo "=============================="
		flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	fi

	if [[ $SHELL != "/usr/bin/fish" ]]; then
		echo "=============================="
		echo "Change shell to fish shell..."
		echo "=============================="
		sudo chsh -s $(which fish) $USER
	fi

	if [[ -e "$PWD/evremap/evremap" ]]; then
		echo "=============================="
		echo "Installing evremap..."
		echo "=============================="
		sudo cp $PWD/evremap/evremap /usr/bin/evremap
		sudo cp $PWD/evremap/logitech-wave-keys.toml /etc/evremap.toml
		sudo cp $PWD/evremap/evremap.service /usr/lib/systemd/system/
		sudo systemctl daemon-reload
		sudo systemctl enable evremap.service
		sudo systemctl start evremap.service
	fi
}

update_os
install_pkgs
configure_pkgs

sudo reboot
