alias ll="ls -al --color"
alias cat="bat -n"

navialias() {
    navi --query ":: $1" --best-match
}

alias dcu="navialias dcu"

# starship
eval "$(starship init zsh)"

# iterm
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# fnm
export PATH="/Users/mario/Library/Application Support/fnm:$PATH"
eval "`fnm env`"

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/mario/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/mario/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/mario/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/mario/google-cloud-sdk/completion.zsh.inc'; fi
