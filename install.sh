#!/usr/bin/bash


PKGS=(git stow curl tldr neovim fish gh mpv wezterm gitui docker radiotray-ng solaar nerd-fonts golang rustup blueman libgle-devel libevdev-devel flatpak)
OS=""
SESSION=""

update_os() {
	if [[ -z $OS ]]; then
		if [[ -f /etc/fedora-release ]]; then
			echo "=============================="
			echo "Begin update OS..."
			echo "=============================="
			OS="fedora"
			if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
				SESSION="wayland"
			fi
			
			sudo dnf -y update
		else
			echo "Unsupported OS."
			exit 1
		fi

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
			if [[ $OS == "fedora" ]]; then
				if [[ $i == "wezterm" ]]; then
					sudo dnf copr enable wezfurlong/$i-nightly -y
				fi

				if [[ $i == "nerd-fonts" ]]; then
					sudo dnf copr enable che/$i -y
				fi

				if [[ $i == "golang" ]]; then
					wget https://go.dev/dl/go1.23.2.linux-amd64.tar.gz
					sudo rm -rf /usr/local/go
					sudo tar -C /usr/local -xzf go1.23.2.linux-amd64.tar.gz
					sudo rm -rf *.tar.gz
					continue
				fi

				if [[ $i == "rustup" ]]; then
					curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile minimal --default-toolchain stable --no-modify-path -y
					continue
				fi

				if [[ $i == "docker" ]]; then
					wget https://download.docker.com/linux/fedora/40/x86_64/stable/Packages/docker-ce-27.3.1-1.fc40.x86_64.rpm
					wget https://download.docker.com/linux/fedora/40/x86_64/stable/Packages/docker-ce-cli-27.3.1-1.fc40.x86_64.rpm
					wget https://download.docker.com/linux/fedora/40/x86_64/stable/Packages/containerd.io-1.7.22-3.1.fc40.x86_64.rpm
					wget https://download.docker.com/linux/fedora/40/x86_64/stable/Packages/docker-buildx-plugin-0.17.1-1.fc40.x86_64.rpm
					wget https://download.docker.com/linux/fedora/40/x86_64/stable/Packages/docker-compose-plugin-2.29.7-1.fc40.x86_64.rpm
					sudo dnf install -y containerd.io-1.7.22-3.1.fc40.x86_64.rpm \
						docker-ce-cli-27.3.1-1.fc40.x86_64.rpm \
						docker-ce-27.3.1-1.fc40.x86_64.rpm \
						docker-buildx-plugin-0.17.1-1.fc40.x86_64.rpm \
						docker-compose-plugin-2.29.7-1.fc40.x86_64.rpm
					sudo systemctl enable docker
					sudo systemctl start docker
					sudo rm -rf *.rpm
					sudo usermod -aG docker $USER
					continue
				fi

				sudo dnf install -y $i
			fi
		else
			echo "$i is already installed: $v"
		fi
	done
}

post_install() {
	if [[ -e "/usr/bin/stow" ]]; then
		echo "=============================="
		echo "Begin stow..."
		echo "=============================="

		if [[ $SESSION == "wayland" ]]; then
			STOW=(dunst fish gitui sway swaylock waybar mpv nvim rofi radiotray-ng solaar wezterm)
		else
			STOW=(dunst fish gitui i3 i3status mpv nvim rofi radiotray-ng solaar wezterm)
		fi

		for i in "${STOW[@]}"; do
			if [[ -d "$HOME/.config/$i" ]]; then
				rm -rf $HOME/.config/$i
				echo "remove existing ~/.config/$i"
			fi

			if [[ $i == "nvim" ]]; then
				git clone https://github.com/dam9000/kickstart-modular.nvim.git $HOME/.config/nvim
				rm -rf $HOME/.config/nvim/lua
				echo "clone & setup ~/.config/$i"
			fi

			stow $i
			echo "stow ~/.config/$i"
		done
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
post_install

sudo reboot
