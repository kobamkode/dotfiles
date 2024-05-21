#! /usr/bin/bash
set -e

printf "Update packages\n"
brew update

printf "\nUpgrade packages\n"
brew upgrade

printf "\nInstall Neovim\n"
brew install neovim ripgrep fd-find
echo -e '\n' >> "$HOME/.zshrc"
echo '# Neovim' >> "$HOME/.zshrc"
echo 'export VISUAL=nvim' >> "$HOME/.zshrc"
echo 'export EDITOR="$VISUAL"' >> "$HOME/.zshrc"

printf "\nInstall Github CLI\n"
brew install gh

printf "\nInstall GitUI\n"
brew install gitui

printf "\nInstall Stow\n"
brew install stow

printf "\nInstall Zoxide\n"
brew install zoxide
echo -e '\n' >> "$HOME/.zshrc"
echo '# Zoxide' >> "$HOME/.zshrc"
echo 'eval "$(zoxide init bash)"' >> "$HOME/.zshrc"

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
echo -e '\n' >> "$HOME/.zshrc"
echo '# Go' >> "$HOME/.zshrc"
echo 'export PATH=$PATH:/usr/local/go/bin' >> "$HOME/.zshrc"

printf "\nInstall NodeJS\n"
brew install fnm
echo 'eval "$(fnm env --use-on-cd)"' >> "$HOME/.zshrc"
. "$HOME/.zshrc"
fnm install --latest

printf "\nAppend aliases into .zshrc\n"
echo -e '\n' >> "$HOME/.zshrc"
echo '# Aliases' >> "$HOME/.zshrc"
echo 'alias ll="ls -al"' >> "$HOME/.zshrc"
. "$HOME/.zshrc"

printf "\nStow dotfiles\n"
stow nvim
stow tmux
stow gitui
