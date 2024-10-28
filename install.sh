#!/usr/bin/bash

PKGS=(git curl tldr neovim fish gh mpv wezterm gitui docker radiotray-ng solaar nerd-fonts rofi golang rustup evremap blueman libgle-devel flatpak)
OS=""

update_os() {
	if [[ -z $OS ]]; then 
		if [[ -f /etc/fedora-release ]]; then
			OS="fedora"
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

				if [[ $i == "evremap" ]]; then
					sudo dnf install -y libevdev-devel
					git clone https://github.com/wez/evremap.git
					continue
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
					continue
				fi

				sudo dnf install -y "$i"
			fi
		else
			echo "$i is already installed: $v"
		fi
	done
}

post_install() {
	if [[ -e "/usr/bin/flatpak" ]]; then
		flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	fi
 
	if [[ $SHELL != "/usr/bin/fish" ]]; then
		sudo chsh -s $(which fish) $USER
	fi
}



update_os
install_pkgs
post_install

sudo reboot 
