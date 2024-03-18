alias ll="ls -al --color"
alias cat="bat -n"

navialias() {
    navi --query ":: $1" --best-match
}

alias dcu="navialias dcu"

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH="/Users/mario/Library/Application Support/fnm:$PATH"
eval "`fnm env`"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/mario/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/mario/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/mario/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/mario/google-cloud-sdk/completion.zsh.inc'; fi
