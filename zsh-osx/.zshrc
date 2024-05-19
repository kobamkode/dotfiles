alias ll="ls -al --color"
# alias cat="bat"

navialias() {
    navi --query ":: $1" --best-match
}

alias dcu="navialias dcu"
alias goblue="go-blueprint create --advanced"

# eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(direnv hook zsh)"

export GOPATH="/Users/mario/go"
export GOBIN="$GOPATH/bin"
export PATH="/Users/mario/Library/Application Support/fnm:$GOBIN:$PATH"
eval "`fnm env`"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/mario/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/mario/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/mario/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/mario/google-cloud-sdk/completion.zsh.inc'; fi
