#!/bin/sh

antibody bundle < "$HOME/.dotfiles/antibody/bundles" > "$HOME/.zsh_plugins.sh"
antibody update
