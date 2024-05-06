#! /usr/bin/bash
set -e

echo "Update packages"
sudo dnf update -y

echo "Upgrade packages"
sudo dnf upgrade -y

echo "Install Neovim"
sudo dnf install neovim ripgrep fd-find -y

echo "Install build-essential"
sudo dnf group install "C Development Tools and Libraries" -y

echo "Install Github CLI"
sudo dnf install gh -y

echo "Install GitUI"
sudo dnf install gitui -y

echo "Install Stow"
sudo dnf install stow -y

echo "Install Zoxide"
sudo dnf copr enable atim/zoxide -y
sudo dnf install zoxide -y
echo eval "$(zoxide init bash)" >> "$HOME/.bashrc"

echo "Install Tmux"
sudo dnf install tmux -y

echo "Clone TPM"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo "Swap Capslock into Esc"
sudo dnf install dconf -y
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"

echo "Install Go"
curl -O https://www.digitalocean.com/robots.txt
sudo rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz
echo export PATH=$PATH:/usr/local/go/bin >> "$HOME/.bashrc"

echo "Append configs into .bashrc"
echo alias ll="ls -al --color" >> "$HOME/.bashrc"
source "$HOME/.bashrc"

echo "Stow dotfiles"
# Change directory to $HOME/dotfiles if not already there
[[ "$PWD" != "$HOME/dotfiles" ]] && cd "$HOME/dotfiles" || :
# Run stow tasks
stow nvim
stow tmux
stow .fonts
stow gitui
