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

echo "Install Tmux"
sudo dnf install tmux -y

echo "Clone TPM"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi

echo "Swap Capslock into Esc"
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"

echo "Append configs into .bashrc"
echo -e eval "$(zoxide init bash)" >> $HOME/.bashrc
echo -e alias ll="ls -al --color" >> $HOME/.bashrc

echo "Stow dotfiles"
if [ "$PWD" != "$HOME/dotfiles" ]; then
cd "$HOME/dotfiles" || exit
stow nvim
stow tmux
stow .fonts
stow gitui
fi

