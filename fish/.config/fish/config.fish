set fish_greeting
set -a fish_user_paths /usr/local/go/bin /home/mario/go/bin

alias ls="ls -al --color"
alias fisource="source ~/.config/fish/config.fish"

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
