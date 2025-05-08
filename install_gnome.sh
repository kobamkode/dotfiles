#!/usr/bin/bash

PKGS=(stow curl tldr neovim tmux gh ghostty gitui docker nerd-fonts golang rustup)
OS=""
SESSION=""

update_os() {
	if [[ -z $OS ]]; then
		if [[ -f /etc/fedora-release ]]; then
			echo "=============================="
			echo "Begin update OS..."
			echo "=============================="
			OS="fedora"
			if [[ "$XDG_SESSION_DESKTOP" == "gnome" ]]; then
				SESSION="gnome"
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
			fi
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

		if [[ $SESSION == "gnome" ]]; then
			STOW=(gitui ghostty tmux)
			# load dconf conf
			# to backup dconf dump / > file
			dconf load / < ./dconf 
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

}

update_os
install_pkgs
configure_pkgs

sudo reboot
