#!/usr/bin/bash

PKGS=(git curl tldr neovim tmux fish gh mpv wezterm gitui radiotray-ng podman podman-compose solaar nerd-fonts rofi golang rustup evremap blueman libgle-devel flatpak)
OS=""

post_install() {
	if [[ -e "$HOME/bin/chezmoi" ]]; then
		sudo mv $HOME/bin/chezmoi /usr/bin/chezmoi
		rm -rf $HOME/bin
	fi

	if [[ $SHELL != "/usr/bin/fish" ]]; then
		sudo chsh -s $(which fish) $USER
	fi

	if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
		git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
	fi

	if [[ -e "/usr/bin/flatpak" ]]; then
		flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	fi

	if [[ ! -e "/home/mario/.cargo/bin/cargo" ]]; then
		rustup-init -y
		source "$HOME/.cargo/env.fish"
	fi

	if [[ ! -e "/usr/bin/evremap" ]]; then
		git clone https://github.com/wez/evremap.git
		cd evremap
		cargo build --release
		sudo cp target/release/evremap /usr/bin/evremap
		sudo cp /home/mario/dotfiles/logitech-wave-keys.toml /etc/evremap.toml
		sudo cp evremap.service /usr/lib/systemd/system/
		sudo systemctl daemon-reload
		sudo systemctl enable evremap.service
		sudo systemctl start evremap.service
	fi

	if [[ -e "/usr/lib/systemd/system/evremap.service" ]]; then
		rm -rf $HOME/evremap $HOME/README.md
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

				if [[ $i == "evremap" ]]; then
					sudo dnf install -y libevdev-devel
					continue
				fi

				sudo dnf install -y "$i"
			fi
		else
			echo "$i is already installed: $v"
		fi
	done
}

update_os() {
	if [[ -z $OS ]]; then 
		if [[ -f /etc/fedora-release ]]; then
			OS="fedora"
			sudo dnf -y update
		else
			echo "Unsupported OS. Please install $PKGS manually."
			exit 1
		fi

	fi
}


update_os
install_pkgs
post_install

sudo reboot
