# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/mario/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

export PATH=$PATH:/usr/local/go/bin

alias ll="ls -al --color"
alias cat="bat -n"

navialias() {
    navi --query ":: $1" --best-match
}

alias dcu="navialias dcu"

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"


# fnm
export PATH="/home/mario/.local/share/fnm:$PATH"
eval "`fnm env`"
