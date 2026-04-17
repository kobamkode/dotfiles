#!/usr/bin/env bash

gum style --background="3" --foreground="0" "  Updating system  "
sudo apt-get update
sudo apt-get upgrade -y

gum style --background="3" --foreground="0" "  Updating mise  "
mise up

gum style --background="3" --foreground="0" "  Updating flatpak  "
flatpak update -y
