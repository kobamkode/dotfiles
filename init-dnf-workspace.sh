#! /usr/bin/bash
set -e

printf "Update packages\n"
sudo dnf update -y

printf "\nUpgrade packages\n"
sudo dnf upgrade -y

printf "\nInstall build-essential\n"
sudo dnf group install "C Development Tools and Libraries" -y

printf "\nInstall Neovim\n"
sudo dnf install neovim ripgrep fd-find -y
echo -e '\n' >> "$HOME/.bashrc"
echo '# Neovim' >> "$HOME/.bashrc"
echo 'export VISUAL=nvim' >> "$HOME/.bashrc"
echo 'export EDITOR="$VISUAL"' >> "$HOME/.bashrc"

printf "\nInstall Github CLI\n"
sudo dnf install gh -y

printf "\nInstall GitUI\n"
sudo dnf install gitui -y

printf "\nInstall Stow\n"
sudo dnf install stow -y

printf "\nInstall Zoxide\n"
sudo dnf copr enable atim/zoxide -y
sudo dnf install zoxide -y
echo -e '\n' >> "$HOME/.bashrc"
echo '# Zoxide' >> "$HOME/.bashrc"
echo 'eval "$(zoxide init bash --cmd cd)"' >> "$HOME/.bashrc"

printf "\nInstall Tmux\n"
sudo dnf install tmux -y

printf "\nClone TPM\n"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
	printf "TPM already exists\n"
fi

printf "\nSwap Capslock into Esc\n"
sudo dnf install dconf -y
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"

printf "\nInstall Go\n"
sudo dnf install golang

printf "\nInstall NodeJS\n"
curl -fsSL https://fnm.vercel.app/install | bash
. "$HOME/.bashrc"
fnm install --latest

printf "\nAppend aliases into .bashrc\n"
echo -e '\n' >> "$HOME/.bashrc"
echo '# Aliases' >> "$HOME/.bashrc"
echo 'alias ll="ls -al --color"' >> "$HOME/.bashrc"
. "$HOME/.bashrc"

printf "\nStow dotfiles\n"
stow nvim
stow tmux
stow fonts
stow gitui
