#!/usr/bin/bash

PKGS=(git zsh curl tldr fzf neovim tmux gh mpv wezterm gitui radiotray-ng podman podman-compose starship zoxide nerd-fonts rofi golang)
OS=""

install_pkgs() {
	for i in "${PKGS[@]}"; do
		if [[ $i == "neovim" ]]; then
			v="$(which nvim 2>/dev/null)"
		else
			v="$(which $i 2>/dev/null)"
		fi

		if [[ -z $v ]]; then
			echo "Installing $i..."
			if [[ $OS == "fedora" ]]; then
				if [[ $i == "wezterm" ]]; then
					sudo dnf copr enable wezfurlong/$i-nightly -y
				fi
				
				if [[ $i == "starship" ]] || [[ $i == "zoxide" ]]; then
					sudo dnf copr enable atim/$i -y
				fi

				if [[ $i == "nerd-fonts" ]]; then
					sudo dnf copr enable che/$i -y
				fi

				if [[ $i == "zsh" ]]; then
					sudo chsh -s $(which zsh) $USER
					continue
				fi

				if [[ $i == "tmux" ]]; then
					git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
				fi

				sudo dnf install -y "$i"
			fi
		else
			echo "$i is already installed: $v"
		fi
	done
}

update_os() {
	echo "Updating $OS..."
	if [[ $OS == "fedora" ]]; then
		sudo dnf -y update
	fi
}

if [[ -z $OS ]]; then 
	if [[ -f /etc/fedora-release ]]; then
		OS="fedora"
	else
		echo "Unsupported OS. Please install $PKGS manually."
		exit 1
	fi

fi

update_os
install_pkgs
