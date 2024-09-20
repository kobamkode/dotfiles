#!/usr/bin/bash

PKGS=(git tldr neovim tmux gh mpv)
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
				sudo dnf install -y "$i"
			fi

			if [[ $OS == "ubuntu" ]]; then
				sudo apt install -y "$i"
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
	
	if [[ $OS == "ubuntu" ]]; then
		sudo apt -y update
	fi

	install_pkgs
}

if [[ -z $OS ]]; then 
	if [[ -f /etc/fedora-release ]]; then
		OS="fedora"
	elif [[ -f /etc/lsb-release ]]; then
		OS="ubuntu"
	else
		echo "Unsupported OS. Please install $PKGS manually."
		exit 1
	fi

fi

update_os
