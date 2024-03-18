# Dotfiles

## Usage

- install `stow`
**fedora**:
```sh
dnf install stow
```
**osx**:
```sh
brew install stow
```
- inside dotfiles folder type `stow [config]`
    - config: is a folder that you want to install

## Config Dependencies

### NVIM

**fedora**:
- install C Development Tools and Libraries group
```sh
dnf group install "C Development Tools and Libraries"
```
**fedora** and **osx**:
- install Go using official [installer](https://go.dev/doc/install)
- install npm using [fnm](https://github.com/Schniz/fnm)

### ZSH

packages need to installed,

- starship
**fedora**:
```sh 
dnf copr enable atim/starship
dnf install starship
```
**osx**:
```
brew install starship
```
- zoxide
**fedora**:
```sh
dnf copr enable atim/zoxide
dnf install zoxide
```
**osx**:
```sh
brew install zoxide
```
- bat
**fedora**:
```sh
dnf install bat
```
**osx**:
```sh
brew install bat
```
### TMUX

- install [TPM](https://github.com/tmux-plugins/tpm)

### WezTerm

**fedora**:
```sh
sudo dnf copr enable wezfurlong/wezterm-nightly
sudo dnf install wezterm
```
**osx**:
```sh
brew tap homebrew/cask-versions
brew install --cask wezterm-nightly
```

### GitUI

**fedora**:
```sh
dnf install gitui
```
**osx**:
```sh
brew install gitui
```
