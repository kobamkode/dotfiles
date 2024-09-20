#!/usr/bin/bash

PKGS=(git curl tldr neovim tmux gh mpv wezterm gitui chezmoi radiotray-ng)
GITHUB_USERNAME="kobamkode"
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
					sudo dnf copr enable wezfurlong/wezterm-nightly -y
					sudo dnf install -y "$i"
				elif [[ $i == "chezmoi" ]]; then
					sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
					sudo mv bin/chezmoi /usr/bin
					rm -rf bin
				else
					sudo dnf install -y "$i"
				fi

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
