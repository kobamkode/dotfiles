#! /usr/bin/env bash
set -e

printf "Update packages\n"
brew update

printf "\nUpgrade packages\n"
brew upgrade

printf "\nInstall Neovim\n"
brew install neovim ripgrep fd
echo '# Neovim' >> "$HOME/.zshrc"
echo 'export VISUAL=nvim' >> "$HOME/.zshrc"
echo 'export EDITOR="$VISUAL"' >> "$HOME/.zshrc"

printf "\nInstall Github CLI\n"
brew install gh

printf "\nInstall GitUI\n"
brew install gitui

printf "\nInstall Stow\n"
brew install stow

printf "\nInstall Starship\n"
brew install starship
echo '# Starship' >> "$HOME/.zshrc"
echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"

printf "\nInstall FZF\n"
brew install fzf
echo '# FZF' >> "$HOME/.zshrc"
echo 'eval "$(fzf --zsh)"' >> "$HOME/.zshrc"

printf "\nInstall Zoxide\n"
brew install zoxide
echo '# Zoxide' >> "$HOME/.zshrc"
echo 'eval "$(zoxide init zsh --cmd cd)"' >> "$HOME/.zshrc"

printf "\nInstall Tmux\n"
brew install tmux

printf "\nClone TPM\n"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
	printf "TPM already exists\n"
fi

printf "\nInstall Go\n"
sudo rm -rf /usr/local/go
brew install go
echo '# Go' >> "$HOME/.zshrc"
echo 'export PATH=$PATH:/usr/local/go/bin' >> "$HOME/.zshrc"

printf "\nInstall NodeJS\n"
brew install fnm
echo '# FNM' >> "$HOME/.zshrc"
echo 'eval "$(fnm env --use-on-cd)"' >> "$HOME/.zshrc"
. "$HOME/.zshrc"
fnm install --latest

printf "\nInstall DevContainer\n"
npm install -g @devcontainers/cli

printf "\nInstall Podman\n"
brew install podman
brew install --cask podman-desktop
sudo podman-mac-helper install
brew install docker docker-buildx
docker network create --subnet=172.18.0.0/24 ticmiedu

printf "\nInstall PHP\n"
brew install php

printf "\nAppend aliases into .zshrc\n"
echo -e '\n' >> "$HOME/.zshrc"
echo '# Aliases' >> "$HOME/.zshrc"
echo 'alias ll="ls -al --color"' >> "$HOME/.zshrc"
echo 'alias dcu="devcontainer up --remove-existing-container --workspace-folder ."' >> "$HOME/.zshrc"
. "$HOME/.zshrc"

printf "\nStow dotfiles\n"
stow nvim
stow tmux
stow gitui
stow starship

printf "\nSetup has finished!\n"
